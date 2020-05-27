use company;

-- Q1
SELECT first_name from employees ORDER BY first_name ASC; 

-- Q2

CREATE INDEX fname_index ON employees(first_name);
SELECT first_name from employees ORDER BY first_name ASC;

-- Q3
SHOW INDEX FROM employees;

-- Q4
CREATE UNIQUE INDEX employee_ix ON employees(emp_no,first_name,last_name);
SELECT emp_no,first_name,last_name FROM employees;


-- Q5 
-- A
EXPLAIN select distinct emp_no from dept_manager where from_date>=
'1985-01-01' and dept_no>= 'd005';
-- B
EXPLAIN select distinct emp_no from dept_manager where from_date>=
'1996-01-03' and dept_no>= 'd005';
-- C

EXPLAIN select distinct emp_no from dept_manager where from_date>=
'1985-01-01' and dept_no<= 'd009';