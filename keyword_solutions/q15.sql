-- Find the average trip duration.
select avg(TIMESTAMPDIFF(minute, started_at, ended_at)) from tripdata;