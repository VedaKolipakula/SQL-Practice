-- Identify the longest trip recorded in the dataset.
select max(TIMESTAMPDIFF(minute, started_at, ended_at)) AS longest from tripdata