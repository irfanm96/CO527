-- Create database company security.
create database company_security;

-- Load the given company security.sql le to the company security database.
-- the relative path is given
source ./company_security.sql;

-- Create a new user ‘user1’ within the MySQL shell.
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'password1';

-- Login to MySQL with a new user account and password and see if the new user
-- has any authorities or privileges to the database.
-- command in shell mysql -u user1 -p password1
SHOW GRANTS FOR 'user1'@'localhost';

-- Make sure the new user has only read only permission to ‘Employee’ table.
show grants for CURRENT_USER;
use company_security;
-- Now allow ‘user1’ to query the followings:
SELECT * FROM company_security.EMPLOYEE;
INSERT into company_security.EMPLOYEE VALUES('1') ;

-- What happens? Fix the problem.
GRANT SELECT,INSERT ON company_security.EMPLOYEE TO 'user1'@'localhost';
FLUSH PRIVILEGES;

--now check again if user1 can do the following quries
SELECT * FROM company_security.EMPLOYEE;
INSERT INTO company_security.EMPLOYEE VALUES('A','B','C',64545454,'1965-01-09','731 asas','M', 40,'333445555',5);

-- From user1 create a view WORKS ON1(Fname,Lname,Pno) on EMPLOYEE and
-- WORKS ON. (Note: You will have to give permission to user1 on CREATE
-- VIEW). Give another user ‘user2’ permission to select tuples from WORKS
-- ON1(Note: user2 will not be able to see WORKS ON or EMPLOYEE).

--as root give permission to create view to user1
GRANT SELECT ON company_security.WORKS_ON TO 'user1'@'localhost';
GRANT CREATE VIEW ON company_security.* TO 'user1'@'localhost';
FLUSH PRIVILEGES;

--as user1
CREATE VIEW company_security.WORKS_ON1 as SELECT Fname,Lname,Pno from company_security.EMPLOYEE as e,company_security.WORKS_ON as w where e.Ssn= w.Essn;

--as root create a anorher user - user2
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'password2';
GRANT SELECT ON company_security.WORKS_ON1 TO 'user1'@'localhost';
GRANT SELECT ON company_security.WORKS_ON1 TO 'user2'@'localhost';
FLUSH PRIVILEGES;

--as user2 Select tuples from user2 account.
SELECT * FROM company_security.WORKS_ON1;

-- Remove privileges of user1 on WORKS ON and EMPLOYEE. Can user1 still
-- access WORKS ON1? What happened to WORKS ON1? Why?
REVOKE ALL ON company_security.EMPLOYEE FROM 'user1'@'localhost';
REVOKE ALL ON company_security.WORKS_ON FROM 'user1'@'localhost';
FLUSH PRIVILEGES;

-- 5. Assignment
-- Account A can retrieve or modify any relation except DEPENDENT and can grant any of
-- these privileges to other users.
GRANT SELECT, UPDATE ON EMPLOYEE, DEPARTMENT, DEPT_LOCATIONS, PROJECT, WORKS_ON TO AccountA WITH GRANT OPTION;

-- Account B can retrieve all the attributes of EMPLOYEE and DEPARTMENT except for
-- Salary, Mgr ssn, and Mgr start date.

--create seperate views with sepecific attributes on the corrsponding tables and grant select access
-- for EMPLOYEE table
CREATE VIEW EMPS AS SELECT Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Super_ssn, Dno FROM EMPLOYEE;
GRANT SELECT ON EMPS TO AccountB;

-- for DEPARTMENT TABLE
CREATE VIEW DEPTS AS SELECT Dname, Dnumber FROM DEPARTMENT;
GRANT SELECT ON DEPTS TO AccountB;

-- Account C can retrieve or modify WORKS ON but can only retrieve the Fname, Minit,
-- Lname, and Ssn attributes of EMPLOYEE and the Pname and Pnumber attributes of
-- PROJECT.
-- grant select and update for works on
GRANT SELECT, UPDATE ON WORKS_ON TO AccountC;
-- create a view for acocunt c with sepecific attributs and grant select
CREATE VIEW EMP_C AS SELECT Fname, Minit, Lname, Ssn FROM EMPLOYEE;
GRANT SELECT ON EMP_C TO AccountC;

CREATE VIEW PROJ_C AS SELECT Pname, Pno FROM PROJECT;
GRANT SELECT ON PROJ_C TO AccountC;

-- Account D can retrieve any attribute of EMPLOYEE or DEPENDENT and can modify
-- DEPENDENT.
GRANT SELECT ON EMPLOYEE, DEPENDENT TO AccountD;
GRANT UPDATE ON DEPENDENT TO AccountD;

-- Account E can retrieve any attribute of EMPLOYEE but only for EMPLOYEE tuples that
-- have Dno = 3.
CREATE VIEW DNO3_EMPLOYEES AS SELECT * FROM EMPLOYEE WHERE Dno = 3;
GRANT SELECT ON DNO3_EMPLOYEES TO AccountE;