-- Count trips by rider type (member vs casual).
select member_casual, COUNT(*) as trip_count
from tripdata
group by member_casual;
