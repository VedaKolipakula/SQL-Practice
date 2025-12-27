-- 5. For each employee, indicate whether their department exists using a derived column (e.g., `has_valid_department`).
select 
 e.employee_id,
 e.first_name, 
 e.last_name, 
 case 
	when d.department_id is NULL then "No department"
    else "Has department"
 end as has_valid_department
from employees as e 
left join departments as d 
on e.department_id = d.department_id