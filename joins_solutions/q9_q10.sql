-- 9. Produce a combined list showing employees with departments, employees without departments, and departments without employees.
select e.employee_id, e.first_name, e.last_name, d.department_name 
from employees as e 
left join departments as d 
on e.department_id = d.department_id

union all 

select d.department_name, e.employee_id, e.first_name, e.last_name 
from employees as e 
right join departments as d
on e.department_id = d.department_id
where e.employee_id is null