Drop database if exists join_database;
CREATE DATABASE join_database;
USE join_database;

-- create two tables table1 and table2

CREATE TABLE table1 (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    phone_number VARCHAR(15)
);


CREATE TABLE table2 (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    salary DECIMAL(10, 2),
    address VARCHAR(100)
);

-- Insert data into table1
INSERT INTO table1 (id, first_name, last_name, city, phone_number) VALUES
(1, 'Rahul', 'Sharma', 'Delhi', '9876543210'),
(2, 'Priya', 'Verma', 'Mumbai', '8765432109'),
(3, 'Amit', 'Patel', 'Ahmedabad', '7654321098'),
(4, 'Anjali', 'Singh', 'Kolkata', '6543210987'),
(5, 'Vijay', 'Kumar', 'Bangalore', '5432109876');

-- Insert data into table2
INSERT INTO table2 (id, first_name, last_name, city, salary, address) VALUES
(3, 'Amit', 'Patel', 'Ahmedabad', 75000.00, 'Street 21, Ahmedabad, Gujarat'),
(4, 'Anjali', 'Singh', 'Kolkata', 82000.00, 'Park Street, Kolkata, West Bengal'),
(5, 'Vijay', 'Kumar', 'Bangalore', 92000.00, 'MG Road, Bangalore, Karnataka'),
(6, 'Sanjay', 'Reddy', 'Hyderabad', 70000.00, 'Banjara Hills, Hyderabad, Telangana'),
(7, 'Megha', 'Iyer', 'Chennai', 88000.00, 'Anna Nagar, Chennai, Tamil Nadu');


CREATE TABLE employees_selfjoin (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT
);

INSERT INTO employees_selfjoin (employee_id, name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2);

-- 1. INNER JOIN with a salary filter

SELECT
   table1.ID, table1.first_name,table1.city,table1.phone_number,table2.salary
   FROM table1
   INNER JOIN table2
   ON table1.ID = table2.ID
   WHERE table2.salary > 75000
   ORDER BY table2.salary DESC;
   
-- 2. LEFT JOIN with a city filter
 
 SELECT
    table1.ID,Table1.first_name,table1.city,table2.salary,table2.address
    FROM table1
    LEFT JOIN table2
    ON table1.id = table2.id
    WHERE table1.city IN ('Delhi','Kolkata','Banglore')
    ORDER BY table1.id ASC;
    
-- 3. RIGHT JOIN with sorting and row limit

SELECT 
     table2.id,table2.first_name,table2.salary,table1.phone_number
     FROM table1
     RIGHT JOIN table2
     ON table1.id = table2.id
     WHERE table2.salary >= 80000
     ORDER BY table2.salary DESC
     LIMIT 2;
     
-- 4. FULL OUTER join result 

SELECT
    COALESCE(table1.id,table2.id) AS id,
    COALESCE(table1.first_name,table2.first_name)AS first_name,
    table1.phone_number,table2.salary
    FROM table1
    LEFT JOIN table2
    ON table1.id = table2.id
    
    UNION
    
SELECT
     COALESCE(table1.id , tatble2.id) AS id,
     COALESCE(table1.first_name , table2.first_name) AS First_name,
     table1.phone_number, table2.salary
     FROM table1
     RIGHT JOIN table2
     ON table1.id = table2.id
     ORDER BY id ASC;
     
-- 5.Cross join with a row limit

SELECT
   table1.id AS table1_id,
   table1.first_name AS table1_name,
   table2.id AS table2_id,
   table2.first_name AS table2_name
   FROM table1
   CROSS JOIN table2
   ORDER BY table1.id ASC , table2.id ASC
   LIMIT 10;
   
-- 6. LEFT JOIN to find people missing from the table2

SELECT table1.*
FROM table1
LEFT JOIN table2
ON table1.id = table2.id
WHERE table2.id IS NULL
ORDER BY table1.first_name ASC;

-- 7. RIGHT JOIN to find people missing from table1

SELECT table2.*
FROM table1
RIGHT JOIN table2
ON table1.id = table2.id
WHERE table1.id IS NULL 
AND table2.salary > 75000
ORDER BY table2.salary DESC;

-- 8. Unmatched people from both tables

SELECT 
table1.id, table1.first_name,
'table1' AS source 
FROM table1
LEFT JOIN table2
ON table1.id = table2.id
where table2.id IS NULL

UNION ALL 

SELECT 
table2.id,
table2.first_name,
'table2' AS source
FROM table2
LEFT JOIN table1
ON table1.id = table2.id
WHERE table1.id IS NULL
ORDER BY first_name ASC, id ASC 
LIMIT 3;
 
 
-- 9. INNER JOIN to find the tow highest salaries

SELECT 
table1.first_name,table1.last_name,table1.city,table1.phone_number,table2.salary
from table1
inner join table2
ON table1.id = table2.id
WHERE table2.salary > 70000
ORDER BY table2.salary DESC , table1.id ASC 
LIMIT 2;

-- 10.Self join to find employees managed by Bob

SELECT 
    e.employee_id,
    e.name AS employee_name,
    m.name AS manager_name 
    From employees_selfjoin e
    INNER JOIN employees_selfjoin m
    ON e.manager_id = m.employee_id
    WHERE m.name= 'Bob'
    ORDER BY e.employee_id DESC
    LIMIT 1;