-- 11. Display each employee along with their manager’s full name.
select e.employee_id, e.first_name, e.last_name, m.first_name as managerfirst, m.last_name as managerlast 
from employees as e 
left join employees as m 
on e.manager_id = m.employee_id