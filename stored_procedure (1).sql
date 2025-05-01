CREATE DATABASE store;
use store;
CREATE TABLE workers (
  Worker_Id INT PRIMARY KEY,
  FirstName varchar(25) NOT NULL,
  LastName varchar(25) NOT NULL,
  Salary INT,
  JoiningDate DATETIME,
  Department varchar(25)
);
select * from workers;

INSERT INTO workers  VALUES
(1001, 'John', 'Doe', 50000, '2023-01-01', 'Engineering'),
(1002, 'Jane', 'Smith', 45000, '2022-06-15', 'Marketing'),
(1003, 'Michael', 'Lee', 60000, '2024-03-12', 'Sales'),
(1004, 'Olivia', 'Jones', 48000, '2021-11-21', 'Human Resources'),
(1005, 'William', 'Brown', 52000, '2023-05-09', 'IT'),
(1006, 'Sophia', 'Davis', 42000, '2022-09-04', 'Finance'),
(1007, 'Benjamin', 'Miller', 55000, '2024-02-10', 'Research & Development'),
(1008, 'Isabella', 'Garcia', 47000, '2021-12-28', 'Customer Service'),
(1009, 'James', 'Rodriguez', 62000, '2023-07-17', 'Management'),
(1010, 'Charlotte', 'Wilson', 51000, '2022-04-03', 'Administration');

select * from workers;

SELECT Salary FROM workers WHERE Worker_Id = 1007;
-- -------------------------------------------------------------------------------

-- Write stored procedure takes in an IN parameter for WORKER_ID and an OUT parameter for SALARY.
--  It should retrieve the salary of the worker with the given ID and returns it in the p_salary parameter. 
-- Then make the procedure call.
DELIMITER //

CREATE PROCEDURE sp_GetSalary (id INT)
BEGIN
  SELECT Salary FROM workers WHERE Worker_Id = id;
END;
// DELIMITER ;

call sp_GetSalary(1000);


select * from workers;

-- Create a stored procedure that takes in IN parameters for all 
-- the columns in the Worker table and adds a new record to the table and then invokes the procedure call.

DELIMITER //

CREATE PROCEDURE sp_AddWorker (
   in_worker_id INT,
   in_first_name CHAR(25),
  in_last_name CHAR(25),
   in_salary INT(15),
   in_joining_date DATETIME,
   in_department CHAR(25)
)
BEGIN
  INSERT INTO workers (Worker_Id, FirstName, LastName, Salary, JoiningDate, Department) VALUES (
    in_worker_id,
    in_first_name,
    in_last_name,
    in_salary,
    in_joining_date,
    in_department
  );
END;

//

DELIMITER ;

CALL sp_AddWorker(1021, 'David', 'Taylor', 49000, '2024-04-25', 'Operations');
select * from workers;


-- ---------------------------------------------------------------------------

  UPDATE workers SET Department = "datascience" WHERE Worker_Id = 1001;

-- 3. Create a stored procedure that takes in IN parameters for WORKER_ID and DEPARTMENT.
-- It should update the department of the worker with the given ID. Then make a procedure call
DELIMITER //
CREATE PROCEDURE dep_update (id INT,dep varchar(25))
BEGIN
  UPDATE workers SET Department = dep WHERE Worker_Id = id;
END;

//

DELIMITER ;

call dep_update(1004,"machine learning");

select * from workers;

select count(*) from workers where department="machine learning";

-- 4.   Write a stored procedure that takes in an IN parameter for DEPARTMENT and an OUT parameter for p_workerCount. 
-- It should retrieve the number of workers in the given department and returns it in the p_workerCount parameter. 
-- Make procedure call.

DELIMITER //
CREATE PROCEDURE number_dep (dep varchar(25))
BEGIN
  select count(*) from workers where department=dep;
END;

//

DELIMITER ;
call number_dep( "it");

select * from workers;

select avg(salary) from workers where department="it";

-- Write a stored procedure that takes in an IN parameter for DEPARTMENT and an OUT parameter for p_avgSalary. It should retrieve the average salary 
-- of all workers in the given department and returns it in the p_avgSalary parameter and call the procedure.
delimiter //
create procedure avg_salaryq1(in depart varchar(20),out avg_salary int)
begin
	 select avg(salary) into avg_salary from workers where department=depart;
end;
//  delimiter ;

call avg_salaryq1("it",@avg_salary);
SELECT @avg_salary AS it_avg_salary;  


drop procedure dep_update;