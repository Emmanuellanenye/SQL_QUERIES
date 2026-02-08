select * from jobs;
select * from locations;
select * from regions;
select * from employees;


--Who are the ABORT
select e.employee_id, concat(e.first_name)' ', e.last_name) as full_name, j.job_title, e.salary, 
        (e.salary - COALESCE(j.max_salary, 0)) as above_average
from employees e
join jobs j
on e .job_id = j .job




--4 Which departments have no employees assigned
select d.department_name, count(e.employee_id)
from departments d
left join employees e
on d.department_id = e.department_id
group by d.department_id
having count(e.employee_id) = 0;


--5. List jobe roles
select job_id, job_title
from jobs
where job_id not in ( select distinct job_id from employees);

-- 6 Which managers
select 
    e.manager_id, concat(f.first_name, ' ', f.last_name) manager,
	count(e.employee_id) report_count, round(avg(e.salary),2) as avg_sal
from employees e
join employees f
on e.manager_id = f.employee_id
group by e.manager_id, manager
having count(e.employee_id) > 5


select l.city, extract(year from e.hire_date) hire_year, count(e.employee_id) head_count
from employees e
join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
group by l.city, hire_year
order by head_count desc;

