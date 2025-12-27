-- 1. List every employee with their department name, returning only employees whose `department_id` matches an existing department.
select e.employee_id, e.first_name, e.last_name, d.department_name
from joinsdata.employees as e
inner join joinsdata.departments as d
on e.department_ID = d.department_ID
