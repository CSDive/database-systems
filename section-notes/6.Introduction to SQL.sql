USE university;


/**************************************************************
  Chapter 3 cont. ( nested subqueries )
  Works for microsoft sql server
**************************************************************/


SELECT 'yes'
WHERE 3 IN (1, 2, 3, 4);

--3.8 Nested Subqueries 
/**************************************************************
  Query: Find instructors that are in physics or history departments.
  schema: Instructor(ID, name, dept_name, salary)
  hint: use in connective to test for set membership ( in )
  follow up: use not in 
	-The not in connective tests for the absence of set membership
**************************************************************/
select * 
from instructor 
where dept_name = 'physIcs' or dept_name = 'history'

select *
from instructor 
where dept_name in ( 'physics', 'history' ) -- this is static list of value ( this can be dynamic ) 

select *
from instructor 
where dept_name not in ('physics', 'history' )

--- note in sql server there is no tuple comparison so you can't do this
select *
from instructor 
WHERE (dept_name, salary) IN (('Physics', 90000), ('Math', 95000)) -- It works in PostgreSQL, MySQL, and Oracle; it's supported by most major RDBMSs -- just not SQL Server (thanks, Microsoft!).


-- to make it dynamic we need something that returns collection of values dynamicly ( it is the select-from-where clause )
/**************************************************************
  Query: Find all the courses taught in the both the Fall 2017 and Spring 2018 semesters.
  
  hint: use in connective to test for set membership ( in )
  notes:
	-This example shows that it is possible to write the same query several ways in SQL.
	-This flexibility is beneficial, since it allows a user to think about the query in the way that seems most natural
**************************************************************/
select course_id from section where semester = 'fall' and year = 2017
intersect
select course_id from section where semester = 'Spring' and year = 2018

select distinct course_id
from section
where semester = 'Fall' and year= 2017 and 
course_id in (select course_id
			  from section
			  where semester = 'Spring' and year= 2018);


/**************************************************************
  Query: Find all the courses taught in the Fall 2017 semester but not in the Spring 2018 semester
		  
**************************************************************/
select distinct course_id
from section
where semester = 'Fall' and year= 2017 and
course_id not in (select course_id
from section
where semester = 'Spring' and year= 2018);


/**************************************************************
  Query: Find the names of all instructors whose salary is greater than at least one instructor in the Biology department.
  - you can use < some, <= some, >= some, = some (in), and <> some
**************************************************************/
select T.name
from instructor as T, instructor as S
where T.salary > S.salary and S.dept_name = 'Biology';

--Only one expression can be specified in the select list when the subquery is not introduced with EXISTS.
select name
from instructor
where salary > some (select salary
from instructor
where dept_name = 'Biology');

SELECT name
FROM Instructor
WHERE salary > ( -- you can't do this if the Subquery returned more than 1 value.
    SELECT MIN(salary)
    FROM Instructor
    WHERE dept_name = 'History'
);

/**************************************************************
  Query: find the names of all instructors that have a salary value greater than that of each instructor in the Biology department. 
  - you can use < all, <= all, >= all, = all, and <> all (not in)
**************************************************************/

select name
from instructor
where salary > all (select salary
from instructor
where dept_name = 'Biology');

SELECT name
FROM Instructor
WHERE salary > (
    SELECT MAX(salary)
    FROM Instructor
    WHERE dept_name = 'Biology'
);


/**************************************************************
  Query: Find the departments that have the highest average salary. (instructor relation)
  - you can use < all, <= all, >= all, = all, and <> all (not in)
  - can be solved using joins?
**************************************************************/
select dept_name
from instructor
group by dept_name
having avg (salary) >= all (select avg (salary)
from instructor
group by dept_name)

/**************************************************************
  Notes: when to use all - some - in
	- use ALL when you are looking for strict condition (higher than everyone else)
	- use SOME when partial match is enough
	- Use ALL or SOME over IN only if you are doing comparisons other than =
**************************************************************/

-- skip exist , unique

-- Subqueries in the From Clause 
/**************************************************************
  Query: Find the average instructors’ salaries of those departments where the average salary is greater than $42,000.
  - SQL allows a subquery expression to be used in the from clause. 
  - The key concept applied here is that any select-from-where expression returns a relation as a result and, therefore, can be inserted into another select-from-where anywhere that a relation can appear.
**************************************************************/
select dept_name, avg(salary) from instructor group by dept_name having avg(salary) > 42000
select dept_name, avg_salary from (
	select dept_name ,avg(salary) avg_salary from instructor group by dept_name) as dept_avg(dept_name, avg_salary)
	where avg_salary > 42000


select dept_name, avg_salary 
from (select dept_name , avg(salary) avg_salary 
	  from instructor 
	  group by dept_name) 
	  as dept_avg(dept_name, avg_salary) -- sql server requires that each subquery relation in the from clause must be given a name, even if the name is never referenced
where avg_salary > 42000

/**************************************************************
  Query: Find the maximum across all departments of the total of all instructors’ salaries in each department.
  - note: having can't help us here.
**************************************************************/
select max(tot_salary)
from (select dept_name, sum(salary) 
	  from instructor
	  group by dept_name) as dept_total (dept_name, tot_salary);



--Scalar Subqueries
/**************************************************************
  Scalar Subquery: A subquery that returns exactly one value — one row and one column. It can be used anywhere a single value is expected, such as:
	- In the `SELECT` clause
	- In the `WHERE` clause
	- In the `HAVING` clause
	- Even in arithmetic expressions
  - note: having can't help us here. <-------------------------------

Characteristics:
	- Returns: A relation with one row and one column.
	- Evaluated as: A value, not a set or relation.
	- If more than one value is returned → runtime error.
	- Can use aggregates (e.g., `COUNT`, `AVG`) to ensure only one value is returned.

first Scalar Subqueries in SELECT Clause
  - Used for computed columns, often with aggregates

**************************************************************/
SELECT name,
       salary,
       (SELECT AVG(salary) FROM instructor) AS avg_salary
FROM instructor;


/**************************************************************
  Query: find the number of instuctors in each department
  notes : 
	- The subquery is correlated: it uses `department.dept_name` from the outer query.
	- This subquery is scalar as it always returns one row and one column (thanks to `COUNT(*)` with no `GROUP BY`)
**************************************************************/
SELECT dept_name,
       (SELECT COUNT(*)  -- counts number of instructor for each department
        FROM instructor
        WHERE department.dept_name = instructor.dept_name)
       AS num_instructors
FROM department;

-- can we do it with cross product
-- we can get the exact result using joins (next time)
select department.dept_name, count(*)  AS num_instructors
from department, instructor
where department.dept_name = instructor.dept_name
group by department.dept_name

