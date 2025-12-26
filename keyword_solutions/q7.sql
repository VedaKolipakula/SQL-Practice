-- Count trips by rideable type.
select rideable_type, count(*) as ridetype
from tripdata 
group by rideable_type