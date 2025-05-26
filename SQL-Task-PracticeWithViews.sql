-- SQL Task: Practice with Views
-- Objective
-- Create and manage views using real-world-style employee and department data.
-- Step 1: Create and Populate Tables
create database viewDB
use viewDB
-- Employees Table:
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary INT,
    DeptID INT
);
INSERT INTO Employees (EmpID, Name, Salary, DeptID)
VALUES
    (1, 'Alice', 60000, 101),
    (2, 'Bob', 45000, 102),
    (3, 'Charlie', 75000, 101),
    (4, 'Diana', 50000, 103),
    (5, 'Eve', 68000, 102);
-- Departments Table:
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100),
    Location VARCHAR(100)
);
INSERT INTO Departments (DeptID, DeptName, Location)
VALUES
    (101, 'Engineering', 'New York'),
    (102, 'Sales', 'Chicago'),
    (103, 'HR', 'San Francisco');

------------


-- Step 2: Your Tasks
-- 1. Create a View `HighEarners`
   -- - Show employee `Name` and `Salary` for employees earning more than 60,000.
   create view HighEarners as select Name , Salary from Employees where Salary>60000

   select * from HighEarners
-- 2. Create a View `EmpDepartmentInfo`
   -- - Join Employees and Departments tables.
   -- - Show: `Name`, `Salary`, `DeptName`, `Location`.
   create view EmpDepartmentInfo as select E.Name ,E.Salary , D.DeptName , D.Location from Employees E inner join Departments D on D.DeptID=E.DeptID

    select * from EmpDepartmentInfo
-- 3. Create a View `ChicagoEmployees`
   -- - Show employees working in the Chicago department.
   create view ChicagoEmployees as select E.Name, D.DeptName from Employees E inner join Departments D on D.DeptID=E.DeptID where D.Location ='Chicago'


   select * from ChicagoEmployees


-- 4. Update the View `HighEarners`
   -- - Modify it to also include `DeptID`.
   alter view HighEarners as select Name, Salary, DeptID from Employees where Salary > 60000;

   select * from HighEarners;

-- 5. Try to Update Data Through View
   -- - Try updating an employee's salary through the `HighEarners` view.
   -- - Was it allowed? Why or why not?
   update HighEarners set Salary = 70000 where Name = 'Eve';
   --it is allowed becouse view is based on a single table (Employees).


-- 6. Delete the View `ChicagoEmployees`
   -- - Use `DROP VIEW`.

	drop view ChicagoEmployees;

-- Bonus Challenge
-- Create a view `DepartmentStats` that shows:
	-- - `DeptName`
	-- - Number of employees in each department
	create view DepartmentStats as select D.DeptName,count(E.EmpID) as 'Employee Count' from Departments D
left join Employees E on D.DeptID = E.DeptID group by D.DeptName;

select * from DepartmentStats;
