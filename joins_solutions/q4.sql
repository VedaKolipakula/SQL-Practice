-- 4. List all employees and their department names, showing `NULL` for the department when an employee has no matching department.
select e.employee_id, e.first_name, e.last_name, d.department_name 
from employees as e 
left join departments as d 
on e.department_id = d.department_id