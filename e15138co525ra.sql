
/*

Titile : SQL srcipt for a company database
course : CO527
Author : E/15/138
       : Irfan M.M.M

A Database is created in the SQL script, So if not neccessary 
Remove the first three lines.
*/


drop database if exists test138;
create database test138;
use test138;


create table department (
  dname char(20) not null,
  dnumber numeric(3) not null,  
  mgrssn numeric(10) not null,   
  mgrstartdate date not null, 
  primary key (dnumber)
);

create table employee (
  fname varchar(100) not null,
  minit char(1),
  lname varchar(100),
  ssn numeric(10) not null,  
  bdate date not null,
  address varchar(30) ,
  sex char(1) not null,
  salary decimal(8,2) not null,
  superssn numeric(10),
  dno numeric(3) not null, 
  primary key (ssn), 
  foreign key (dno) references department(dnumber)
); 

create table project (
  pname varchar(50) not null,
  pnumber numeric(10) not null,  
  plocation varchar(50) not null,
  dnum numeric(3) not null, 
  primary key (pnumber), 
  foreign key (dnum) references department(dnumber)
); 

create table works_on (
  essn numeric(10) not null,  
  pno numeric(10) not null, 
  hours numeric(5,1),  
  primary key (essn, pno), 
  foreign key (essn) references employee(ssn) on update cascade on delete cascade,
  foreign key (pno) references project(pnumber) on update cascade on delete cascade
); 

create table dependent (
  essn numeric(10) not null,  
  dependent_name varchar(50) not null,
  sex char(1) not null,
  bdate date not null,
  relationship varchar(30) not null,
  primary key (essn, dependent_name),
  foreign key (essn) references employee(ssn) on update cascade on delete cascade
); 

create table dept_locations (
  dnumber numeric(3) not null,
  dlocation char (15) not null,
  primary key (dnumber, dlocation), 
  foreign key (dnumber) references department(dnumber)
);

insert into department values 
 ('Research',5,333445555,'1988-05-22'),
 ('Administration',4,987654321,'1995-01-01'),
 ('Headquarters',1,888665555,'1981-06-19');

insert into employee values 
 ('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
 ('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
 ('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
 ('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),
 ('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
 ('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
 ('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),
 ('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1);

insert into project values 
 ('ProductX',1,'Bellaire',5),
 ('ProductY',2,'Sugarland',5),
 ('ProductZ',3,'Houston',5),
 ('Computerization',10,'Stafford',4),
 ('Reorganization',20,'Houston',1),
 ('Newbenefits',30,'Stafford',4);

insert into works_on values 
 (123456789,1,32.5),
 (123456789,2,7.5),
 (666884444,3,40.0),
 (453453453,1,20.0),
 (453453453,2,20.0),
 (333445555,2,10.0),
 (333445555,3,10.0),
 (333445555,10,10.0),
 (333445555,20,10.0),
 (999887777,30,30.0),
 (999887777,10,10.0),
 (987987987,10,35.0),
 (987987987,30,5.0),
 (987654321,30,20.0),
 (987654321,20,15.0),
 (888665555,20,null);

insert into dependent values 
 (333445555,'Alice','F','1986-04-04','Daughter'),
 (333445555,'Theodore','M','1983-10-25','Son'),
 (333445555,'Joy','F','1958-05-03','Spouse'),
 (987654321,'Abner','M','1942-02-28','Spouse'),
 (123456789,'Michael','M','1988-01-04','Son'),
 (123456789,'Alice','F','1988-12-30','Daughter'),
 (123456789,'Elizabeth','F','1967-05-05','Spouse');

insert into dept_locations values
 (1,'Houston'),
 (4,'Stafford'),
 (5,'Bellaire'),
 (5,'Sugarland'),
 (5,'Houston');

alter table department 
 add constraint mgr foreign key (mgrssn) references employee(ssn);

alter table employee   
 add constraint supervise foreign key (superssn) references employee(ssn);
