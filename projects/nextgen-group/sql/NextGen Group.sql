select * from attendance;
select * from department;
select * from employee;
select * from performance;
select * from salary;
select * from turnover;

----------EMPLOYEE RETENSION ANALYSIS
--1.Who are the top 5 highest serving employees?
select * from employee
limit 5;

--2.What is the turnover rate for each department?
SELECT 
    d.department_name,
    COUNT(t.employee_id) AS employees_left,
    COUNT(e.employee_id) AS total_employees,
    ROUND(
        (COUNT(t.employee_id)::decimal / NULLIF(COUNT(e.employee_id), 0)) * 100, 
        2
    ) AS turnover_rate_percent
FROM 
    Department d
LEFT JOIN 
    Employee e ON e.department_id = d.department_id
LEFT JOIN 
    Turnover t ON t.employee_id = e.employee_id
GROUP BY 
    d.department_name;

--3 Which employees are at risk of leaving based on their performance?
SELECT 
  e.employee_id,
  e.first_name || ' ' || e.last_name AS full_name,
  d.department_name,
  p.performance_score
FROM 
  employee e
JOIN 
  performance p ON e.employee_id = p.employee_id
JOIN 
  Department d ON e.department_id = d.department_id
LEFT JOIN 
  Turnover t ON e.employee_id = t.employee_id
WHERE 
  p.performance_score < 3.5
ORDER BY 
  p.performance_score ASC;

--4. What are the main reasons employees are leaving the company?
select * from turnover;  
SELECT 
  reason_for_leaving,
  COUNT(*) AS number_of_employees
FROM 
  turnover t
GROUP BY 
  t.reason_for_leaving; 

-----------PERFORMANCE  ANALYSIS
--1. How many employees has left the company?
SELECT 
  COUNT(*) AS turnover_id
FROM 
  turnover
WHERE 
  turnover_date IS NOT NULL;

--2. How many employees have a performance score of 5.0 / below 3.5?
SELECT 
  COUNT(*) AS performance_score
FROM 
  performance
WHERE 
  performance_score = 5.0;

SELECT 
  COUNT(*) AS performance_score
FROM 
  performance
  WHERE 
  performance_score < 3.5;

--3. Which department has the most employees with a performance of 5.0 / below 3.5?
SELECT
    d.department_name,
    SUM(CASE WHEN p.performance_score = 5.0 THEN 1 ELSE 0 END) AS perfect_score_count,
    SUM(CASE WHEN p.performance_score < 3.5 THEN 1 ELSE 0 END) AS low_score_count
FROM
    employee e
JOIN
    department d ON e.department_id = d.department_id
JOIN
    performance p ON e.employee_id = p.employee_id
GROUP BY
     d.department_id, d.department_name, p.performance_score
ORDER BY
    p.performance_score DESC;

	
--4. What is the average performance score by department?
SELECT 
d.department_name,
ROUND(AVG(pr.performance_score), 2) AS avg_performance_score
FROM 
performance pr
JOIN 
 employee e ON pr.employee_id = e.employee_id
JOIN 
 department d ON e.department_id = d.department_id
GROUP BY 
d.department_name
ORDER BY 
avg_performance_score DESC;

-----------SALARY ANALYSIS
--1. What is the total salary expense for the company?
SELECT 
  SUM(salary_amount) AS total_salary_expense
FROM 
  salary;
	
--2. What is the average salary by job title?
SELECT 
  e.job_title,
  ROUND(AVG(s.salary_amount), 2) AS avg_salary_amount
FROM 
  employee e
JOIN 
  salary s ON e.employee_id = s.employee_id
GROUP BY 
  e.job_title
ORDER BY 
  avg_salary_amount DESC;

--3. How many employees earn above 80,000?
SELECT 
  COUNT(*) AS salary_amount
FROM 
  salary
WHERE 
  salary_amount > 80000;

--4. How does performance correlate with salary across departments?
SELECT 
    d.department_name,
    ROUND(AVG(p.performance_score), 2) AS avg_performance,
    ROUND(AVG(s.salary_amount), 2) AS avg_salary
FROM employee e
JOIN department d ON e.department_id = d.department_id
JOIN performance p ON e.employee_id = p.employee_id
JOIN salary s ON e.employee_id = s.employee_id
GROUP BY d.department_name;



























  































































