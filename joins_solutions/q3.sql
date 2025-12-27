-- 3. Find employees whose salary is higher than the average salary of their own department.
select t.employee_id, t.salary, t.department_name, t.avgsalary
from (
	select e.employee_id, e.salary, d.department_name, AVG(e.salary) OVER (PARTITION BY d.department_name) AS avgsalary from employees as e
    inner join departments as d 
    on e.department_id = d.department_id
) as t 
where t.salary > t.avgsalary