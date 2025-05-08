USE university;

-- ( there is natural join (not supported in sql server) search for it.
-- also search for `using` (not supported also)  	
/**************************************************************
  Chapter 4 cont. (natural join - inner join, outer join, left join, right join)
  Works for microsoft sql server
**************************************************************/
--4.1 Join Expressions
/**************************************************************
  remember student, takes relations
  student( id, name, dept_name, tot_cred)
  takes( id, course_id, sec_id, semester, year, grade)
**************************************************************/
select * from student
select * from takes

--4.1 natural join ( not supported => solved using inner join)
/**************************************************************
  Query: For all students in the university who have taken some course, find their names and the course ID of all courses they took

performance considuration
INNER JOIN
	- Matches rows based on a condition (ON).
	- Skips non-matching rows early → efficient (don't generate these unmatched rows).
	- Indexes on join columns improve performance.
	- Optimizer may reorder joins for better speed.

CROSS JOIN
	- Combines all rows from both tables (Cartesian product) Very costly.
	- Filters later using WHERE.
	- Very costly if tables are large.
	- Avoid unless all combinations are needed.

 - every join operation should be followed by `on` except for cross join
**************************************************************/
select * 
from student, takes
where student.id = takes.id

select * 
from student cross join takes
where student.id = takes.id

select *
from student inner join takes --inner join is the default so inner can be omitted
on student.id = takes.id


/**************************************************************
  Query: List the names of students along with the titles of courses that they have taken.

  notes: inner join is binary relations 
		 - so inner join must be fully calculated for 2 relations only and the resulting relation is intered to the next join operation
		 - the sql engine need `on` to get the resulting relation
**************************************************************/
select name, title
from student join takes on student.id = takes.id
	 join course on  takes.course_id = course.course_id


-- inner join doesn't add expressive power as it can be expressed in cross join
select name, title 
from student cross join takes, course
where student.id = takes.id and takes.course_id = course.course_id

select name, title
from student join takes on student.id = takes.id 
cross join course
where takes.course_id = course.course_id

select name, title
from course cross join takes join student
on student.id = takes.id
where takes.course_id = course.course_id

-- On vs Where 
/***************************
When to use ON vs WHERE
 - Technically, you can move ON conditions to WHERE with a cross join.
 - ON is essential for outer joins to behave correctly.
 - Writing join conditions in ON and filters in WHERE makes queries more readable.
***************************/

--4.1.3 Outer Joins
/**************************************************************
  Query: A list of all students, displaying their ID, and name, dept_name, and tot_cred, along with the courses that they have taken. 
  
- using inner join some tuples in either or both of the relations being joined may be lost.

outer join
	- The outer-join operation works in a manner similar to the join operations we have already studied, but it preserves those tuples that would be lost in a join by creating tuples in the result containing null values.

There are three types of outer joins:
	- Left outer join: Preserves matched tuples and unmatched tuples from the left relation.
	- Right outer join: Preserves matched tuples and unmatched tuples from the right relation.
	- Full outer join: Preserves matched tuples and unmatched tuples from both relations.

Unlike inner joins, which exclude non-matching tuples, outer joins preserve unmatched ones by filling in missing attributes with null values. Eg. For a left outer join, the unmatched tuples from the left relation are added with nulls for the right relation's attributes.
**************************************************************/
select * from student -- show that student Snow hasn't taken any course
select * from takes

select * 
from student left outer join takes -- outer can be omitted
on student.id = takes.id

/**************************************************************
  Query: find students that don't take any course

  2 solutions
**************************************************************/
select * 
from student left join takes on student.id = takes.id
where takes.id is null

select *
from student 
where student.id not in (select takes.id from takes)

/**************************************************************
  Query: A list of all students, displaying their ID, and name, dept_name, and tot_cred, along with the courses that they have taken.

  solve it using right outer join
**************************************************************/
select *
from takes right outer join student
on takes.id = student.id

/**************************************************************
	query: list all students along with the course ID and course title they are enrolled in. 
		   Ensure that the list includes all students and all courses, even if a student has not enrolled in any course or if a course has no enrolled students.

How to understand the full outer join: The full outer join is a combination of the left and right outer-join types. After the operation computes the result of the inner join, it extends with nulls those tuples from the left-hand-side relation that did not match with any from the right-hand-side relation and adds them to the result. Similarly, it extends with nulls those tuples from the righthand-side relation that did not match with any tuples from the left-hand-side relation and adds them to the result. Said differently, full outer join is the union of a left outer join and the corresponding right outer join
**************************************************************/
select name, takes.course_id, title
from student full join takes on student.ID = takes.id
	 full outer join course on takes.course_id = course.course_id


-- note: where and on behaves differently for the outer joins
select *
from student left outer join takes on student.ID = takes.ID

select *
from student left outer join takes on 1 = 1
where student.ID = takes.ID;


-- Joins don't add expressive power:
-- Any join (inner, outer) can be rewritten using cross product + selection (WHERE).
/**************************************************************
  Query: A list of all students, displaying their ID, and name, dept_name, and tot_cred, along with the courses ids that they have taken. without using outer join
**************************************************************/
select * 
from student left outer join takes -- outer can be omitted
on student.id = takes.id


select * from student, takes where student.id = takes.id
union
select *, null, null, null, null, null, null from student 
where student.id not in ( select takes.id from takes)

-- self join
-- find pairs of students who are in the same department
select * 
from student s1 join student s2 on s1.dept_name = s2.dept_name 
where s1.id < s2.id -- why <

-- 3.9 Modification of the Database
-- 3.9.1 Delete Statement
/**************************************************************
	- you can only delete tuples in one table (eg. Instructor) based on conditions
	- there are some problems that will arise if you violated some constraints (eg. foreign key constraints)
**************************************************************/
use university6
select * from instructor
-- 1. Delete all instructors in the Finance department
DELETE FROM instructor
WHERE dept_name = 'Finance';
select * from instructor

-- 2. Delete all instructors with a salary between 13000 and 15000
DELETE FROM instructor
WHERE salary BETWEEN 13000 AND 15000;


-- 3. Delete all instructors associated with departments in the Watson building
DELETE FROM instructor
WHERE dept_name IN (
    SELECT dept_name
    FROM department
    WHERE building = 'Watson'
);

-- can be written using join
DELETE i
FROM instructor AS i
INNER JOIN department AS d ON i.dept_name = d.dept_name
WHERE d.building = 'Watson';

-- 4. Delete all instructors whose salary is below the university average salary
DELETE FROM instructor
WHERE salary < (
    SELECT AVG(salary)
    FROM instructor
);

/**************************************************************
how deletion works
In SQL Server (and most RDBMSs), the DELETE statement first collects all rows matching the WHERE, then deletes them all at once, not one-by-one.
This prevents inconsistency (for example, average salary won't change during deletion).

Start
  ↓
Read DELETE statement
  ↓
Identify target table (e.g., instructor)
  ↓
Is there a WHERE clause?
 ├── Yes → Evaluate the WHERE condition
 │          ↓
 │     Does tuple satisfy the condition?
 │       ├── Yes → Mark tuple for deletion
 │       └── No  → Ignore tuple
 └── No → Mark all tuples for deletion
  ↓
After scanning all tuples
  ↓
Delete all marked tuples in a single batch operation
  ↓
Commit changes (if auto-commit is ON) 
  ↓
End
**************************************************************/
-- 3.9.2 INSERT

-- insert new course
-- Insert values in order as per table definition:
INSERT INTO course
VALUES ('CS-437', 'Database Systems', 'Comp. Sci.', 4),
('CS-439', 'Database Systems', 'Comp. Sci.', 4)


-- you can specify columns explicitly (order can vary):

INSERT INTO course (course_id, title, dept_name, credits)
VALUES ('CS-437', 'Database Systems', 'Comp. Sci.', 4);

INSERT INTO course (title, course_id, credits, dept_name)
VALUES ('Database Systems', 'CS-437', 4, 'Comp. Sci.');
-- it is Good practice to  specify column names to avoid mistakes if schema changes.


-- Insert Multiple Tuples Using a Query
 -- make each student in the Music department who has earned more than 144 credit hours an instructor in the Music department with a salary of $18,000. 
 select * from instructor
INSERT INTO instructor
SELECT ID, name, dept_name,  40000
FROM student
WHERE dept_name = 'Music' AND tot_cred > 30;
-- note: sql engine first executes the SELECT, collects all tuples, then inserts them.
-- Avoids infinite loops (example: inserting from a table into itself).
insert into student 
select *
from student;


-- Insert with Missing Columns (NULL values)
-- insert a student but the tot_cred is unknown

INSERT INTO student
VALUES ('3003', 'Green', 'Finance', NULL);

---

-- Bulk Insertions
-- notes
	-- Always match data types of the inserted values.
	-- Respect NOT NULL and PRIMARY KEY constraints.
	-- Be careful when inserting from `SELECT *` — it must match column numbers and types.


-- 3.9.3 Update Statement
/**************************************************************
general form
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
**************************************************************/

-- Increase all instructor salaries by 5%
UPDATE instructor
SET salary = salary * 1.05;
select * from instructor

-- increase salaries only for instructors earning less than $70,000
UPDATE instructor
SET salary = salary * 1.05
WHERE salary < 70000;

-- increase salaries for instructors earning below average by 5%
UPDATE instructor -- just same as deletion the update statement is done at the end 
SET salary = salary * 1.05
WHERE salary < (
    SELECT AVG(salary)
    FROM instructor
);

-- all instructors with salary over $100,000 receive a 3 percent raise, whereas all others receive a 5 percent raise.
-- note that the order matters here (right?)
UPDATE instructor
SET salary = salary * 1.03
WHERE salary > 100000;

UPDATE instructor
SET salary = salary * 1.05
WHERE salary <= 100000;

-- Do it with a single statement using `CASE`.

UPDATE instructor
SET salary = CASE -- Case statements can be used in any place where a value is expected.
    WHEN salary <= 100000 THEN salary * 1.05
    ELSE salary * 1.03
END; -- now you don't worry about the order

-- increase the salary of all instructors that their departement is in Watson building (you can still use join :( )
UPDATE instructor
SET salary = salary * 1.05
FROM instructor
JOIN department ON instructor.dept_name = department.dept_name
WHERE department.building = 'Watson';

