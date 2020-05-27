

DROP DATABASE IF EXISTS company; 

CREATE DATABASE company;

USE company;

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
	#primary key (title), 
	#foreign key (emp_no) references employees(emp_no)
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


#import all files before runnnig these quires


SELECT 'employees' AS table_name, COUNT(*) FROM employees 
UNION 
SELECT 'depts' AS departments, COUNT(*) FROM departments 
UNION 
SELECT 'dept_manger' AS dept_manager, COUNT(*) FROM dept_manager 
UNION 
SELECT 'dept_emp' AS dept_emp, COUNT(*) FROM dept_emp
UNION 
SELECT 'titles' AS titles, COUNT(*) FROM titles 
UNION 
SELECT 'salaries' AS salaries, COUNT(*) FROM salaries;


SELECT last_name as family_name FROM employees GROUP BY last_name ORDER BY COUNT(*) DESC LIMIT 10;


SELECT dept_no, COUNT(dept_emp.emp_no) from dept_emp, titles where titles.emp_no = dept_emp.emp_no and titles.title = "Engineer" GROUP BY dept_emp.dept_no;


SELECT * from employees, dept_manager, titles where dept_manager.emp_no = employees.emp_no and employees.sex = 'F' 
and titles.emp_no = employees.emp_no and titles.title = "Senior Engineer";
