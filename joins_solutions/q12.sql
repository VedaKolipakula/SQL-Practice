-- 12. List all pairs of employees who belong to the same department, excluding self-pairings.
select e.department_id, e.first_name, e.last_name, m.department_id, m.first_name, m.last_name
from employees as e 
inner join employees as m
on e.department_id = m.department_id
where e.employee_id <> m.employee_id