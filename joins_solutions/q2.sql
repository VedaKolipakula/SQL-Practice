-- 2. Show each department name along with the total number of employees in that department, including only departments that have at least one employee.
select d.department_name, count(e.employee_id) as total_employees
from departments as d
inner join employees as e
on d.department_id = e.department_id
group by d.department_name