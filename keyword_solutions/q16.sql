-- Compare average trip duration between members and casual riders.
select avg(TIMESTAMPDIFF(minute, started_at, ended_at)) as average_time, member_casual as member_type from tripdata
group by member_casual