-- task_6

CREATE TABLE deptmst (
  deptno INT PRIMARY KEY,
  deptname VARCHAR(20),
  location VARCHAR(15)
);

CREATE TABLE employee (
  empno INT PRIMARY KEY,
  empname VARCHAR(15) NOT NULL,
  deptno INT,
  salary DECIMAL(8,2),
  dob DATE,
  city VARCHAR(10),
  FOREIGN KEY (deptno) REFERENCES deptmst(deptno)
);


INSERT INTO deptmst VALUES 
(10, 'HR', 'Mumbai'),
(20, 'IT', 'Delhi'),
(30, 'Finance', 'Kolkata'),
(40, 'Marketing', 'Chennai');

INSERT INTO employee VALUES
(1001, 'Alice', 10, 55000.00, '1990-05-12', 'Mumbai'),
(1002, 'Bob', 20, 62000.50, '1988-03-20', 'Delhi'),
(1003, 'Charlie', 30, 47000.75, '1992-08-15', 'Kolkata'),
(1004, 'Diana', 10, 58000.00, '1991-11-02', 'Pune'),
(1005, 'Ethan', 40, 75000.00, '1985-07-30', 'Chennai'),
(1006, 'Fiona', 20, 69000.00, '1993-01-15', 'Delhi');

-- 1. Subquery in SELECT (Scalar Subquery)
-- Show employee name, salary, and department average salary

SELECT 
  empname,
  salary,
  (SELECT AVG(salary) 
   FROM employee e2 
   WHERE e2.deptno = e1.deptno) AS dept_avg_salary
FROM employee e1;

-- 2. Subquery in WHERE using IN
-- Employees in departments located in 'Delhi' or 'Chennai'

SELECT empname, city 
FROM employee 
WHERE deptno IN (
  SELECT deptno 
  FROM deptmst 
  WHERE location IN ('Delhi', 'Chennai')
);

-- 3. Subquery in WHERE using EXISTS (Correlated)
-- List departments that have employees

SELECT deptname 
FROM deptmst d 
WHERE EXISTS (
  SELECT 1 
  FROM employee e 
  WHERE e.deptno = d.deptno
);

-- 4. Subquery in FROM
-- Departments and employee count

SELECT d.deptname, emp_count 
FROM deptmst d
JOIN (
  SELECT deptno, COUNT(*) AS emp_count 
  FROM employee 
  GROUP BY deptno
) AS dept_summary ON d.deptno = dept_summary.deptno;

-- 5. WHERE with Scalar Subquery using =
-- Employees earning above the average salary

SELECT empname, salary 
FROM employee 
WHERE salary > (
  SELECT AVG(salary) 
  FROM employee
);

-- 6. Correlated Subquery with Salary Comparison
-- Employees who earn more than at least one person in their department

SELECT empname, salary, deptno
FROM employee e1
WHERE salary > ANY (
  SELECT salary 
  FROM employee e2 
  WHERE e2.deptno = e1.deptno AND e2.empno <> e1.empno
);

-- 7. Using NOT EXISTS
-- Departments that have no employees

SELECT deptname 
FROM deptmst d
WHERE NOT EXISTS (
  SELECT 1 
  FROM employee e 
  WHERE e.deptno = d.deptno
);

-- 8. Employees whose salary is equal to the maximum in their department

SELECT empname, salary, deptno
FROM employee e1
WHERE salary = (
  SELECT MAX(salary)
  FROM employee e2
  WHERE e2.deptno = e1.deptno
);

-- 9. Employees older than the average DOB (earlier date = older)

SELECT empname, dob 
FROM employee 
WHERE dob < (
  SELECT AVG(julianday(dob))
  FROM employee
);

-- 10. Top 1 highest paid employee using subquery (scalar)

SELECT empname, salary 
FROM employee
WHERE salary = (
  SELECT MAX(salary)
  FROM employee
);
