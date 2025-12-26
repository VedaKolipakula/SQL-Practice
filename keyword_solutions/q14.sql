-- Calculate trip duration in minutes for each ride.
select ride_id,TIMESTAMPDIFF(minute, started_at, ended_at) AS minutes from tripdata;