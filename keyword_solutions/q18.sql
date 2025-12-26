-- Find the top 5 end stations for casual riders.
select end_station_name as end_station, count(end_station_name) as count from tripdata
where member_casual = "casual"
group by end_station
order by count desc
limit 5