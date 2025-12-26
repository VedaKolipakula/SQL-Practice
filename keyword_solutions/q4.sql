-- Find all trips that started at a specific station (e.g., Eckhart Park).
select * from tripdata
where start_station_name  = "Eckhart Park"