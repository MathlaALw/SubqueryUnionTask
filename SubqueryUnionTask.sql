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
