-- 8. Identify departments that currently have no employees assigned.
select d.department_name, e.employee_id, e.first_name, e.last_name 
from employees as e 
right join departments as d
on e.department_id = d.department_id
where e.employee_id is null