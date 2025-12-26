-- Extract the trip start date for each ride.
select ride_id,
date(started_at) as trip_start_date
from tripdata