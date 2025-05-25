-- Topics:
-- 1. UNION / UNION ALL
-- 2. DROP vs DELETE vs TRUNCATE
-- 3. Subqueries (exploratory task – they search and try it)
-- 4. Transaction & Batch Script (exploratory and guided)
-- 5. *Hands-on comparison with real effect on data
-- Practice Scenario: Training & Job Application System
-- Your institute is managing two main datasets:
-- • Trainees: People who complete training at your institute.
-- • Job Applicants: External applicants who apply directly to job posts.
-- Your goal is to:
-- • Compare the data of both groups.
-- • Clean or restructure the database safely.
-- • Explore more advanced SQL topics on your own (subqueries, transactions).

-- create database 

Create database SubqueryUnionTask;
use SubqueryUnionTask
-- Tables

-- Trainees Table
CREATE TABLE Trainees (
 TraineeID INT PRIMARY KEY,
 FullName VARCHAR(100),
 Email VARCHAR(100),
 Program VARCHAR(50),
 GraduationDate DATE
);
-- Job Applicants Table
CREATE TABLE Applicants (
 ApplicantID INT PRIMARY KEY,
 FullName VARCHAR(100),
 Email VARCHAR(100),
 Source VARCHAR(20), -- e.g., "Website", "Referral"
 AppliedDate DATE
);


-------------------------
-- Sample Data
-- Insert into Trainees
INSERT INTO Trainees VALUES
(1, 'Layla Al Riyami', 'layla.r@example.com', 'Full Stack .NET', '2025-04-30'),
(2, 'Salim Al Hinai', 'salim.h@example.com', 'Outsystems', '2025-03-15'),
(3, 'Fatma Al Amri', 'fatma.a@example.com', 'Database Admin', '2025-05-01');
-- Insert into Applicants
INSERT INTO Applicants VALUES
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'),
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'), -- same person as trainee
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28');

-----


select * from Applicants
select * from Trainees
-- Part 1: UNION Practice
-- 1. List all unique people who either trained or applied for a job.
-- o Show their full names and emails.
-- o Use UNION (not UNION ALL) to avoid duplicates.
SELECT FullName, Email FROM Trainees
UNION
SELECT FullName, Email FROM Applicants;

-- 2. Now use UNION ALL. What changes in the result?
-- o Explain why one name appears twice.
SELECT FullName, Email FROM Trainees
UNION ALL
SELECT FullName, Email FROM Applicants;

 -- Layla Al Riyami appears twice in UNION ALL because she is in both tables.-- 
 --  UNION removes duplicates; UNION ALL includes all records.-- 


-- 3. Find people who are in both tables.
-- o You must use INTERSECT if supported, or simulate it using INNER JOIN on Email.

SELECT T.FullName, T.Email
FROM Trainees T
INNER JOIN Applicants A ON T.Email = A.Email;




-- Part 2: DROP, DELETE, TRUNCATE Observation
-- Let’s test destructive commands.
-- Write your observations after each command.


-- 4. Try DELETE FROM Trainees WHERE Program = 'Outsystems'.
-- o Check if the table structure still exists.
DELETE FROM Trainees WHERE Program = 'Outsystems';

-- Observation: Row deleted, but table and other data remain.

-- 5. Try TRUNCATE TABLE Applicants.
-- o What happens to the data? Can you roll it back?
TRUNCATE TABLE Applicants;

-- Observation: All rows removed quickly. Cannot roll back in most DBs (non-logged operation).

-- 6. Try DROP TABLE Applicants.
-- o What happens if you run a SELECT after that?
DROP TABLE Applicants;
-- Observation: Table is permanently removed. SELECT after DROP gives an error.
-- Example:
-- SELECT * FROM Applicants; -- Will fail


-- Part 3: Self-Discovery & Applied Exploration
-- In this section, you’ll independently research, experiment, and apply advanced SQL concepts.
-- Follow the guided prompts below.
-- Subquery Exploration
-- Goal: Understand what a subquery is and how it's used inside SQL commands.


-- 1. Research:
-- o What is a subquery in SQL?
-- * A subquery is a query nested inside another SQL query. It returns data that can be used by the outer (main) query. 

-- o Where can we use subqueries? (e.g., in SELECT, WHERE, FROM)
-- * Subqueries can be used in several parts of an SQL statement:

-- 1. SELECT (to return a value for each row)

-- 2. FROM (as a derived table or inline view)

-- 3. WHERE (commonly used to filter rows based on results from another query)

-- 4. HAVING (for filtering aggregated data)
use SubqueryUnionTask

-- 2. Task:
-- o Write a query to find all trainees whose emails appear in the applicants table.
-- o You must use a subquery inside a WHERE clause.
SELECT *
FROM Trainees
WHERE Email IN (SELECT Email FROM Applicants);

-- 3. Extra Challenge:
-- o Write a DML statement (like UPDATE or DELETE) that uses a subquery in the WHERE clause.
-- o Example: Delete all applicants whose email matches someone in the trainees table.

DELETE FROM Applicants WHERE Email IN ( SELECT Email FROM Trainees );

------

-- Batch Script & Transactions
-- Goal: Understand how to safely execute multiple SQL statements as a unit.
-- 4. Research:
-- o What is a SQL transaction?

-- A SQL transaction is a group of one or more SQL operations executed as a single logical unit of work.
-- Transactions ensure data integrity by guaranteeing that either all operations succeed (COMMIT) or none take effect (ROLLBACK).


-- o How to write transaction blocks in your database tool (BEGIN TRANSACTION, COMMIT, ROLLBACK)?
BEGIN TRANSACTION;

-- SQL statements

COMMIT; -- saves the changes
-- or
ROLLBACK; -- undoes all the changes in the block

-- 5. Task:
-- o Write a script that:
-- ▪ Starts a transaction
-- ▪ Tries to insert two new applicants
-- ▪ The second insert should have a duplicate ApplicantID (to force failure)
-- ▪ Rollback the whole transaction if any error occurs

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Applicants (ApplicantID, FullName, Email, Source, AppliedDate)
    VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');

    -- This insert will fail due to duplicate ApplicantID
    INSERT INTO Applicants (ApplicantID, FullName, Email, Source, AppliedDate)
    VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11');

    COMMIT; -- Only reached if both inserts succeed
END TRY
BEGIN CATCH
    ROLLBACK; -- Reverts all changes if any error occurs
    select ERROR_LINE() ,ERROR_MESSAGE(), ERROR_NUMBER()

END CATCH;

-- 6. Add this logic:
-- BEGIN TRANSACTION;
-- INSERT INTO Applicants VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');
-- INSERT INTO Applicants VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11'); -- Duplicate IDCOMMIT;
-- Or use ROLLBACK if needed


BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Applicants 
    VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');

    INSERT INTO Applicants 
    VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11'); -- Duplicate ID

    COMMIT; -- If both inserts succeed
END TRY
BEGIN CATCH
    ROLLBACK; -- Undo both inserts
    select ERROR_LINE() ,ERROR_MESSAGE(), ERROR_NUMBER()
END CATCH;

----------------

-- ACID Properties Exploration
-- Goal: Learn the theory behind reliable transactions.
-- 7. Research and summarize each of the ACID properties:
-- o Atomicity
--  - Ensures that all parts of a transaction are completed successfully or none are applied. A transaction is treated as a single, indivisible unit of work.
-- o Consistency
--  - Ensures that a transaction brings the database from one valid state to another, maintaining all defined rules and constraints.
-- o Isolation
--  - Ensures that concurrent transactions do not interfere with each other. Each transaction behaves as if it's the only one in the system.
-- o Durability
--  - Ensures that once a transaction is committed, its changes are permanent, even in the case of a system crash or power failure.


-- 8. For each property, write a real-life example that explains it in your own words

-- 1. Atomicity
-- Example: You send money via a banking app either the money leaves your account and reaches the other person, or nothing happens at all.

-- 2. Consistency
-- Example: A shopping website won’t let you order more items than are in stock — it always keeps data valid.

-- 3. Isolation
-- Example: Two people trying to book the same seat only one gets it, the system handles them one at a time.

-- 4. Durability
-- Example: You get a payment confirmation, and even if the server crashes, the transaction is still saved.

