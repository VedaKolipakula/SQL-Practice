-- 13. Find employees who earn a higher salary than their direct manager.
select e.salary as emp_salary, e.first_name, e.last_name, m.salary as manager_salary, m.first_name as managerfirst, m.last_name as managerlast 
from employees as e 
left join employees as m 
on e.manager_id = m.employee_id
where e.salary > m.salary