-- Find the top 10 most popular start stations.
select start_station_name as start_station, count(start_station_name) as count from tripdata
group by start_station
order by count desc
limit 10
