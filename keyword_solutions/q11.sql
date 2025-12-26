-- Count the number of trips per day.
select date(started_at) as trip_date,
count(*) as trips 
from tripdata
group by date(started_at)
order by trip_date