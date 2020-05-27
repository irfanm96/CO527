--Execute the following transaction for the salary table updates.

-- start transaction command given in the pdf (the emp_no is changed)
select * from salaries where emp_no=201772;
start transaction;
update salaries set salary = 1.1*salary where emp_no=201772;
-- check if the salary is updated
select * from salaries where emp_no=201772;
rollback;
-- salary should be as before if we do a rollback
select * from salaries where emp_no=201772;


--1. I of ACID
/* I. Issue a select query to view the current status of the department table in both sessions. */
select * from departments;
/*
II. Now, start transaction running start transaction in both sessions.
III. Insert a new row into the departments table from the 1st session and check if the changes are visible in the second session.
*/
-- in session 1
start transaction;
insert into departments values("d500","test department");

-- in session 2
start transaction;
select * from departments;
/*
IV. Commit changes in the 1st command window and check if you can see the updates done at 1st window in 2nd command window.
*/
-- in session 1
commit;

-- in session 2
select * from departments;


--2. Concurrent Updates
/*
I. Try to do a concurrent update to the same row in departments table during two transactions
*/
-- in session 1
start transaction;
update departments set dept_name ="session 1 dept" where dept_no = "d500";

-- in session 2
start transaction;
update departments set dept_name ="session 2 dept" where dept_no = "d500";
/*
III. What happens when you commit your changes in the 1st session.
*/

-- in session 1
commit;
select * from departments where dept_no = "d500";

-- in session 2
select * from departments where dept_no = "d500";


/* Scenario of a banking application
*/
-- create the account table
CREATE TABLE accounts (
    account_no int,
    balance float
);
-- seed an entry for testing
insert into accounts values(15138,20000);

--withdraw 500 from transaction 1
start transaction;
update accounts set balance = balance - 500 where account_no = 15138;


--withdraw 1000 from transaction 2
start transaction;
update accounts set balance = balance - 1000 where account_no = 15138;