create database triggersclass;
use triggersclass;
show tables;

CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    name VARCHAR(20),
    age INT
);
select * from customers;
-- ------------------------------------------------------------------------------------------
-- before insert
DELIMITER //

CREATE TRIGGER modify_customer_data
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    -- Ensure the age is the absolute value
    SET NEW.age = ABS(NEW.age);

    -- Capitalize the name column
    SET NEW.name = UPPER(NEW.name);
END//

DELIMITER ;

INSERT INTO customers (cust_id, name, age) 
VALUES (1, 'ammu', 27), (2, 'appu', -10);

SELECT * FROM customers;

--  You should use the NEW keyword to reference the incoming row data in the trigger, not the table name.




select * from customers;

-- ---------------------------------------------------------------------------------
-- after insert
 create table customer1(id int auto_increment primary key,
 name varchar(50) not null, email varchar(50),birthdate date);
 
 select * from customer1;
 
CREATE TABLE message (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT,
    message VARCHAR(300)
);



DELIMITER //

CREATE TRIGGER check_null_dob 
AFTER INSERT ON customer1
FOR EACH ROW
BEGIN 
    IF NEW.birthdate IS NULL THEN 
        INSERT INTO message (message_id, message) 
        VALUES (NEW.id, CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
    END IF;
END //

DELIMITER ;

insert into customer1 values(1,"deepu","deppuq123",null),(3,"deepa","rtr","2024-12-11");

select * from customer1;
select * from message;
-- ---------------------------------------------------------------------------------------------
-- before update 

CREATE TABLE departments (
    name VARCHAR(100),
    dep VARCHAR(50),
    salary_amount DECIMAL(10, 2),
    roll INT
);
INSERT INTO departments (name, dep, salary_amount, roll) 
VALUES 
('Alice', 'HR', 60000.00, 101),
('Bob', 'Finance', 75000.50, 102),
('Charlie', 'IT', 85000.75, 103),
('Diana', 'Marketing', 50000.00, 104);



select * from departments;
DELIMITER //

CREATE TRIGGER upd_data
BEFORE update  ON departments
FOR EACH ROW
BEGIN
	IF NEW.dep = "hr" THEN
        SET NEW.salary_amount = 50000;
    ELSEIF NEW.dep != "hr" THEN
        SET NEW.salary_amount = 45000;
    END IF;
END //

DELIMITER ;


update departments set dep="hr" where name="bob";
update departments set dep="it" where name="diana";


select * from departments;
-- --- 20/08

drop trigger salary_delete;


select * from salary;

-- -----------------------------------------------------------------------
-- after update
-- Step 1: Create the main table
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    position VARCHAR(100),
    salary FLOAT
);

-- Step 2: Insert some data into the main table
INSERT INTO employees (name, position, salary)
VALUES 
('mahesh', 'data analyst', 75000),
('Jane Smith', 'Developer', 60000),
('Mike Brown', 'Designer', 50000);

select * from employees;

-- Step 3: Create the log table to store update history
CREATE TABLE update_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    old_name VARCHAR(100),
    new_name VARCHAR(100),
    old_position VARCHAR(100),
    new_position VARCHAR(100),
    old_salary FLOAT,
    new_salary FLOAT,
    update_time TIMESTAMP DEFAULT NOW()
);

-- Step 4: Create the AFTER UPDATE trigger
DELIMITER //

CREATE TRIGGER after_employee_update 
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO update_log(employee_id, old_name, new_name, old_position, new_position, old_salary, new_salary)
    VALUES (OLD.id, OLD.name, NEW.name, OLD.position, NEW.position, OLD.salary, NEW.salary);
END; //

DELIMITER ;

update employees set position="data scientist",salary=100000  where id=1;

-- Step 5: Update a record to test the trigger
UPDATE employees
SET name = 'Johnathan Doe', position = 'Senior Manager',salary=287897 
WHERE id = 1;

-- Step 6: Check the log table to see the logged update
SELECT * FROM update_log;


-- ------------------------------------------------------------------------

# before delete

-- Step 1: Create the main table
CREATE TABLE employeee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    position VARCHAR(100),
    salary FLOAT
);

-- Step 2: Insert some data into the main table
INSERT INTO employeee (name, position, salary)
VALUES 
('arathy', 'data scientist', 75000),
('Jane Smith', 'Developer', 60000),
('Mike Brown', 'Designer', 50000);

select * from employeee;

-- Step 3: Create the backup table
CREATE TABLE employees_backup (
    id INT,
    name VARCHAR(100),
    position VARCHAR(100),
    salary FLOAT,
    del_date TIMESTAMP DEFAULT NOW()
);

-- Step 4: Create the BEFORE DELETE trigger
DELIMITER //

CREATE TRIGGER before_employee_deletes
BEFORE DELETE ON employeee
FOR EACH ROW
BEGIN
    INSERT INTO employees_backup(id, name, position, salary)
    VALUES (OLD.id, OLD.name, OLD.position, OLD.salary);
END; //

DELIMITER ;

-- Step 5: Delete a record to test the trigger
DELETE FROM employeee WHERE id = 1;

-- Step 6: Check the backup table to see the deleted data
SELECT * FROM employees_backup;

select * from employeee;
show triggers;
-- -------------------------------------------------------------------------------------------
--
-- Step 1: Create the log table
CREATE TABLE delete_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    deleted_id INT,
    deleted_name VARCHAR(100),
    action_time TIMESTAMP DEFAULT NOW()
);

-- Step 2: Create the AFTER DELETE trigger
DELIMITER //

CREATE TRIGGER after_employee_delete 
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO delete_log(deleted_id, deleted_name)
    VALUES (OLD.id, OLD.name);
END; //

DELIMITER ;

-- Step 3: Delete a record to test the trigger
DELETE FROM employees WHERE id = 2;

-- Step 4: Check the log table to see the log entry
SELECT * FROM delete_log;

