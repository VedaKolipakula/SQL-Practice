-- Count trips by hour of the day.
select count(*) as trip_count, hour(started_at) as start_hour 
from tripdata 
group by hour(started_at) 