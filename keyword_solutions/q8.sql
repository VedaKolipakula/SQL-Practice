-- Find trips where the start station is different from the end station.
select * from tripdata 
where start_station_name <> end_station_name