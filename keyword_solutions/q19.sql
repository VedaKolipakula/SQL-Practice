-- Rank start stations by total number of trips.
select start_station_name as start_station, RANK() OVER (ORDER BY count(start_station_name) DESC) AS rank_num from tripdata
group by start_station