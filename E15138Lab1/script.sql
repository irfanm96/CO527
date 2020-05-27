/**
   Author  : Irfan M.M.M
             E/15/138
   Subject : Advanced DB Systems         
   Lab    ​ : 01
   Topic   : Review on SQL
**/

DROP DATABASE IF EXISTS company; 

CREATE DATABASE company;

USE company;

/* create tables */
create table employees (
	emp_no int not null,
	birth_date date not null,	
	first_name varchar(14) not null,
	last_name varchar(16),
	sex ENUM('M','F'),
	hire_date date not null,	
	primary key (emp_no)
); 

create table titles (
	emp_no int not null,
	title varchar(50) not null,
	from_date date not null,
	to_date date not null,
	primary key (emp_no,title),
	foreign key (emp_no) references employees(emp_no)
); 

create table salaries (
	emp_no int not null,
	salary int not null,
	from_date date not null,
	to_date date not null,
	primary key (emp_no,from_date,to_date), 
	foreign key (emp_no) references employees(emp_no)
); 

create table departments (
	dept_no char(4) not null,
	dept_name varchar(40) not null,
	primary key (dept_no) 
); 


create table dept_manager (
	emp_no int not null,
	dept_no char(4) not null,
	from_date date not null,
	to_date date not null,
	primary key (dept_no,emp_no),
	foreign key (emp_no) references employees(emp_no),
	foreign key (dept_no) references departments(dept_no)
); 


create table dept_emp (
	emp_no int not null,
	dept_no char(4) not null,
	from_date date not null,
	to_date date not null,
	primary key (emp_no,dept_no),
	foreign key (emp_no) references employees(emp_no),
	foreign key (dept_no) references departments(dept_no)
); 

/* load data from sql files, can replace the relative path with the absolute path if this script is used, please add the .sql resource files in data folder and run the start sql console ousite the data folder, or change these paths to absolute paths*/
source ./data/load_employees.sql;
source ./data/load_titles.sql;
source ./data/load_departments.sql;
source ./data/load_dept_emp.sql;
source ./data/load_dept_manager.sql;
source ./data/load_salaries1.sql;
source ./data/load_salaries2.sql;


/*---------------Q1--------------------*/
SELECT 'employees' AS table_name, COUNT(*) FROM employees 
UNION 
SELECT 'dept_manger' AS dept_manager, COUNT(*) FROM dept_manager 
UNION 
SELECT 'dept_emp' AS dept_emp, COUNT(*) FROM dept_emp
UNION 
SELECT 'titles' AS titles, COUNT(*) FROM titles 
UNION 
SELECT 'salaries' AS salaries, COUNT(*) FROM salaries
UNION 
SELECT 'depts' AS departments, COUNT(*) FROM departments;

/*---------------Q2--------------------*/
SELECT last_name as family_name FROM employees GROUP BY last_name ORDER BY COUNT(*) DESC LIMIT 10;

/*---------------Q3--------------------*/
SELECT dept_name, COUNT(dept_emp.emp_no) as Engineers from departments,dept_emp, titles where titles.emp_no = dept_emp.emp_no and titles.title = "Engineer" and dept_emp.dept_no = departments.dept_no GROUP BY dept_emp.dept_no;


/*---------------Q4--------------------*/
SELECT employees.emp_no , first_name, last_name from  dept_manager, titles, employees 
where employees.sex= 'F' 
and titles.emp_no = employees.emp_no
and dept_manager.emp_no = employees.emp_no
and titles.emp_no = dept_manager.emp_no
and titles.title = "Senior Engineer";


/*---------------Q5--------------------*/
SELECT dept_name,titles.title,COUNT(dept_emp.emp_no) from departments,dept_emp, titles, salaries
where titles.emp_no = dept_emp.emp_no 
and dept_emp.dept_no = departments.dept_no
and salaries.salary > 115000
and salaries.emp_no = dept_emp.emp_no
GROUP BY dept_emp.dept_no , titles.title;


/*---------------Q6--------------------*/
SELECT first_name,last_name, (year(CURRENT_DATE())- year(birth_date)) as age , (year(CURRENT_DATE())- year(hire_date)) as years_of_service 
FROM employees 
WHERE (year(CURRENT_DATE())- year(birth_date)) > 50
and  (year(CURRENT_DATE())- year(hire_date)) > 10;


/*---------------Q7--------------------*/
SELECT CONCAT(first_name , ' ', last_name) as name  from employees 
where emp_no not in (
SELECT dept_emp.emp_no from dept_emp, departments 
where departments.dept_name = "Human Resources"
and dept_emp.emp_no = departments.dept_no
);


/*---------------Q8--------------------*/
SELECT DISTINCT CONCAT(first_name , ' ', last_name) as name from employees, salaries 
where employees.emp_no = salaries.emp_no 
and salaries.salary >  (
	SELECT max(salary) from salaries, departments, dept_emp
	where departments.dept_name = "Finance"
	and departments.dept_no = dept_emp.dept_no
	and salaries.emp_no = dept_emp.emp_no
);


/*---------------Q9--------------------*/
SELECT DISTINCT CONCAT(first_name , ' ', last_name) as name from employees, salaries 
where employees.emp_no = salaries.emp_no 
and salaries.salary > (
	SELECT AVG(salary) from salaries
);


/*---------------Q10--------------------*/
SELECT t2.avg2 as SeniorEngineerSalary, t1.avg1 as AVGSalary , abs(t2.avg2 - t1.avg1) as difference 
FROM 
    (SELECT AVG(salary) as avg1 FROM salaries) t1
LEFT JOIN
    (SELECT AVG(salary) as avg2 from salaries, titles
where titles.emp_no = salaries.emp_no
and titles.title = "Senior Engineer") t2
ON (1 = 1);


/*---------------Q11. Q12--------------------*/

CREATE VIEW current_dept_emp as
SELECT emp_no, MAX(from_date) as from_date, MAX(to_date) as to_date  from dept_emp GROUP BY emp_no;


CREATE VIEW current_dept_emp_with_dept_no as
SELECT current_dept_emp.emp_no, current_dept_emp.from_date, current_dept_emp.to_date, dept_no  from current_dept_emp, dept_emp 
where current_dept_emp.emp_no = dept_emp.emp_no
and current_dept_emp.from_date = dept_emp.from_date
and current_dept_emp.to_date = dept_emp.to_date;

SELECT * from current_dept_emp_with_dept_no LIMIT 10;




/*---------------Q13--------------------*/

DROP TRIGGER IF EXISTS `salary_update`;
delimiter //
Create Trigger salary_update
AFTER Update On salaries
For Each Row
Begin
 IF (new.salary > old.salary) Then
  /* print the difference from new.salary - old.salary , but in mysql there is no way of printing to the console,
	it can only throw errors like in the other example, or we have to write the changes to a new table
	as of now this throws a warnig
   */
   	SIGNAL SQLSTATE '01234' set MESSAGE_TEXT = 'salary increment is done';
 End IF;
End;
//
delimiter ;





/*---------------Q14--------------------*/

DROP TRIGGER IF EXISTS `salary_error`;
delimiter //
Create Trigger salary_error
Before Update On salaries
For Each Row
Begin
 IF (new.salary > (old.salary * 1.1)) Then
	signal sqlstate '45000' set message_text = 'Cannot increse more than 10%';
 End IF;
End;
//
delimiter ;

UPDATE `salaries` SET `salary` = '67600' WHERE `salaries`.`emp_no` = 201772 AND `salaries`.`from_date` = '2000-11-25' AND `salaries`.`to_date` = '2001-11-25';
