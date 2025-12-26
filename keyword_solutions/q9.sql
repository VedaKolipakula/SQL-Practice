-- Count trips with missing start or end station information.
select count(*) as missing_station_trips
from tripdata 
where (start_station_name is null) or (end_station_name is null)