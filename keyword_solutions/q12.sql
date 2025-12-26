-- Find all trips that occurred in April 2020.
select * from tripdata
where started_at >= "2020-04-01" and started_at < "2020-05-01"