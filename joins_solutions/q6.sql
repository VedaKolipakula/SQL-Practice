-- 6. Identify employees whose department exists but the department does not have a manager assigned.
select e.employee_id, e.first_name, e.last_name, d.department_name, d.manager_id
from employees as e 
left join departments as d
on e.department_id = d.department_id
where (d.department_name is not null) and (d.manager_id is null)