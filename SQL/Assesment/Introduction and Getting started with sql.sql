-- QUESTION 1:

create database CompanyDB ;

use CompanyDB ;

create table worker (
	worker_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    salary int,
    joining_date  datetime,
    department varchar(50)
);

insert into worker (worker_id, first_name, last_name, salary, joining_date, department)
values
(1, 'Monika', 'Arora', 100000, '2014-02-20 09:00:00', 'HR'),
(2, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(3, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(4, 'Amitabh', 'Singh', 500000, '2014-02-20 09:00:00', 'Admin'),
(5, 'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(6, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(7, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(8, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

-- 1. Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME 
-- Ascending and DEPARTMENT Descending.

select * from worker

order by first_name asc, department desc;

-- 2.Write an SQL query to print details for Workers with the first names      
-- from the Worker table. 
-- “Vipul” and “Satish” 

select * from worker

where first_name in ('Vipul', 'Satish');

-- 3. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘h’ and 
-- contains six alphabets. 

select * from worker

where first_name like '_____h';

-- 4. Write an SQL query to print details of the Workers whose SALARY lies between 1. 

select * from worker

where salary between 100000 and 500000;

-- 5. Write an SQL query to fetch duplicate records having matching data in some fields of a table. 

select first_name, last_name, salary, department,count(*) from worker
group by first_name, last_name, salary, department
having count(*) > 1;

-- 6. Write an SQL query to show the top 6 records of a table. 

select * from worker

limit 6;

-- 7. Write an SQL query to fetch the departments that have less than five people in them. 

select department, count(*) as workerCount from worker
group by department
having count(*) < 5;

-- 8. Write an SQL query to show all departments along with the number of people in there. 

select department, count(*) as workerCount from worker
group by department;

-- 9. Write an SQL query to print the name of employees having the highest salary in each 
-- department.

select w1.* from worker w1
where salary = (select max(salary) from worker w2 where w1. department = w2.department);
