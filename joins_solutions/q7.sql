-- 7. List all departments and the employees assigned to them, including departments with zero employees.
select d.department_name, e.employee_id, e.first_name, e.last_name 
from employees as e 
right join departments as d
on e.department_id = d.department_id