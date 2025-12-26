Perfect — use **Divvy bike share trip data (Chicago)** as your “SQL expert” public-data project. It’s **huge, real, and analytics-friendly** (timestamps, stations, user types, ride duration), which makes it ideal for **GROUP BY \+ window functions \+ RANK/DENSE\_RANK**. Divvy publishes monthly historical trip data for public use. ([Divvy Bikes](https://divvybikes.com/system-data?utm_source=chatgpt.com))

## **Public dataset to use**

* **Divvy historical trip data (monthly downloads)** ([Divvy Bikes](https://divvybikes.com/system-data?utm_source=chatgpt.com))  
* Metadata listing on Data.gov (“Divvy Trips”) ([Data.gov](https://catalog.data.gov/dataset/divvy-trips?utm_source=chatgpt.com))

---

## **Project: “Divvy Demand & Station Performance Analytics”**

### **Goal**

Build a mini analytics layer that answers:

* Which stations are busiest by month/day/hour?  
* Which routes are trending?  
* Which stations are “most improved” vs last month?  
* Rankings per neighborhood/area proxy (you can start with station-only)

---

## **1\) Schema (beginner-friendly but realistic)**

### **`divvy_trips`**

Columns vary slightly by year, but you can normalize like this:

* `ride_id` (PK)  
* `rideable_type`  
* `started_at` (timestamp)  
* `ended_at` (timestamp)  
* `start_station_id`  
* `start_station_name`  
* `end_station_id`  
* `end_station_name`  
* `member_casual` (member/casual)  
* `duration_sec` (computed)

### **`stations` (optional but nice)**

* `station_id` (PK)  
* `station_name`  
* `lat`, `lng` (if available in your extract)

Tip: even if station lat/lng isn’t present in every file, you can create `stations` by unioning distinct station IDs/names from trips.

---

## **2\) Core SQL tasks (covers “all features”)**

### **A) GROUP BY \+ HAVING (foundations)**

1. **Trips and avg duration by member type**  
* trips, avg duration, median duration (if your DB supports it)  
2. **Busiest stations**  
* top start stations by month  
* include only stations with \>= N rides (HAVING)  
3. **Peak hours**  
* rides by hour-of-day \+ weekday/weekend

### **B) CTEs \+ subqueries (clean professional SQL)**

4. Create a reusable `base_trips` CTE that:  
* filters invalid trips  
* computes duration  
* derives `trip_date`, `trip_month`, `dow`, `hour`

### **C) Window functions (the expert jump)**

5. **RANK vs DENSE\_RANK** busiest stations per month  
6. **Running total** rides over time  
7. **Percent share** of monthly rides per station  
8. **Month-over-month change** with `LAG()`  
9. **Top-N per group** (month, member type, station, etc.)

---

## **3\) “Must include” sample SQL (ranking \+ windows)**

### **Step 1: Clean \+ derive fields (CTE)**

WITH base\_trips AS (  
  SELECT  
    ride\_id,  
    started\_at,  
    ended\_at,  
    start\_station\_id,  
    start\_station\_name,  
    end\_station\_id,  
    end\_station\_name,  
    member\_casual,  
    EXTRACT(EPOCH FROM (ended\_at \- started\_at))::bigint AS duration\_sec,  
    DATE\_TRUNC('month', started\_at) AS trip\_month  
  FROM divvy\_trips  
  WHERE started\_at \< ended\_at  
)  
SELECT \* FROM base\_trips;

### **Step 2: Station monthly totals \+ RANK / DENSE\_RANK**

WITH base\_trips AS (  
  SELECT  
    ride\_id,  
    start\_station\_id,  
    start\_station\_name,  
    member\_casual,  
    DATE\_TRUNC('month', started\_at) AS trip\_month  
  FROM divvy\_trips  
  WHERE started\_at \< ended\_at  
),  
station\_monthly AS (  
  SELECT  
    trip\_month,  
    start\_station\_id,  
    start\_station\_name,  
    COUNT(\*) AS rides  
  FROM base\_trips  
  GROUP BY trip\_month, start\_station\_id, start\_station\_name  
)  
SELECT  
  trip\_month,  
  start\_station\_name,  
  rides,  
  RANK() OVER (PARTITION BY trip\_month ORDER BY rides DESC)       AS rank\_rides,  
  DENSE\_RANK() OVER (PARTITION BY trip\_month ORDER BY rides DESC) AS dense\_rank\_rides  
FROM station\_monthly  
ORDER BY trip\_month, rank\_rides, start\_station\_name;

### **Step 3: Top 10 stations per month (classic “top-N per group”)**

WITH station\_ranked AS (  
  \-- reuse the station\_monthly query above and add dense\_rank  
  SELECT  
    trip\_month,  
    start\_station\_name,  
    rides,  
    DENSE\_RANK() OVER (PARTITION BY trip\_month ORDER BY rides DESC) AS rnk  
  FROM (  
    SELECT  
      DATE\_TRUNC('month', started\_at) AS trip\_month,  
      start\_station\_name,  
      COUNT(\*) AS rides  
    FROM divvy\_trips  
    WHERE started\_at \< ended\_at  
    GROUP BY 1, 2  
  ) x  
)  
SELECT \*  
FROM station\_ranked  
WHERE rnk \<= 10  
ORDER BY trip\_month, rnk, start\_station\_name;

### **Step 4: Month-over-month growth per station (LAG)**

WITH station\_monthly AS (  
  SELECT  
    DATE\_TRUNC('month', started\_at) AS trip\_month,  
    start\_station\_name,  
    COUNT(\*) AS rides  
  FROM divvy\_trips  
  WHERE started\_at \< ended\_at  
  GROUP BY 1, 2  
),  
with\_mom AS (  
  SELECT  
    trip\_month,  
    start\_station\_name,  
    rides,  
    LAG(rides) OVER (PARTITION BY start\_station\_name ORDER BY trip\_month) AS rides\_prev\_month  
  FROM station\_monthly  
)  
SELECT  
  trip\_month,  
  start\_station\_name,  
  rides,  
  rides\_prev\_month,  
  (rides \- rides\_prev\_month) AS mom\_change,  
  CASE WHEN rides\_prev\_month \> 0  
       THEN (rides \- rides\_prev\_month) \* 1.0 / rides\_prev\_month  
  END AS mom\_change\_pct  
FROM with\_mom  
ORDER BY trip\_month, mom\_change DESC NULLS LAST;

### **Step 5: Share of rides within a month (percent-of-total window)**

WITH station\_monthly AS (  
  SELECT  
    DATE\_TRUNC('month', started\_at) AS trip\_month,  
    start\_station\_name,  
    COUNT(\*) AS rides  
  FROM divvy\_trips  
  WHERE started\_at \< ended\_at  
  GROUP BY 1, 2  
)  
SELECT  
  trip\_month,  
  start\_station\_name,  
  rides,  
  rides \* 1.0 / SUM(rides) OVER (PARTITION BY trip\_month) AS share\_of\_month  
FROM station\_monthly  
ORDER BY trip\_month, share\_of\_month DESC;

---

## **4\) “Checklist” of SQL features this project hits**

* ✅ SELECT / WHERE / ORDER BY  
* ✅ INNER JOIN (if you add stations table), UNION (build stations dimension)  
* ✅ GROUP BY / HAVING / aggregates  
* ✅ CTEs (`WITH`)  
* ✅ Window functions: `RANK`, `DENSE_RANK`, `LAG`, running totals, percent-of-total  
* ✅ Time-series analytics: month/day/hour extraction, MoM trends  
* ✅ Top-N per group pattern (one of the most common interview tasks)

---

If you tell me which database you’re using (**Postgres / MySQL / SQL Server / BigQuery / Snowflake**), I’ll tailor the exact syntax (especially the timestamp functions \+ duration calculation) and give you a **10-query “curriculum” order**from beginner → expert using this same dataset.
commit