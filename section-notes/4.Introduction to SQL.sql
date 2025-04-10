USE university;
-- insert into instructor values ('10211', 'Smith', 'Biology', 66000);


/**************************************************************
  - Basic SELECT Statements ( SQL basics, filtering, comparison and logical operators, Cartesian-product, aliases, arithmetic in queries, and set operations ) 
  - Works for microsoft sql server
**************************************************************/

--3.3.1 Queries on a Single Relation
/**************************************************************
  query: Find the names of all instructors.
  schema: Instructor(ID, name, dept_name, salary)
**************************************************************/
select name
from instructor;

/**************************************************************
  Find the department names of all instructors 
  key notes: (distinct - all - sorted) r
**************************************************************/
select dept_name
from instructor;
select distinct dept_name
from instructor;

/**************************************************************
  all instructors with salary per month
  you can make arithmetic on attributes
  Note: no change on the stored data
**************************************************************/
select ID, name, dept_name, salary / 12
from instructor;
select * from instructor


/**************************************************************
  return instructors that are in physics department && earning more than 90,000 
  you can use logical connectives and, or, and not in the predicate
  you can use comp. operators <, <=, >, >=, =, and <>
**************************************************************/
SELECT *
FROM Instructor
WHERE dept_name='Physics' and salary > 90000;

/**************************************************************
  department where department name = building name   schema: department(dept_name, building, budget) 
**************************************************************/
select * 
from department 
where dept_name = building;




-- queries on multiple relations
/**************************************************************
  Cartesian-product  instructor x teaches  
  Instructor(ID, name, dept_name, salary)
  teaches(ID, course id, sec_id, semester, year) 
  course(course_id, title, dept_name, credits)
  Key note: Cartesian product not very useful directly, 
			but useful combined with where-clause condition 
			(selection operation in relational algebra). 
**************************************************************/
select * from instructor, teaches;


/**************************************************************
  Select ID and name of instructor corresponding with their course id they teaches
  Instructor(ID, name, dept_name, salary)
  teaches(ID, course id, sec_id, semester, year) 
  course(course_id, title, dept_name, credits)
  Key note: For common attributes (e.g., ID), the attributes in the resulting table
			are renamed using the  relation name (e.g., instructor.ID)
**************************************************************/
select * from instructor, teaches where instructor.ID = teaches.ID
select instructor.ID, name, course_id from instructor, teaches where instructor.ID = teaches.ID

/**************************************************************
  Find the names of all instructors in the Comp. Sci. department 
  who have taught some course and the course_id
  Instructor(ID, name, dept_name, salary)
  teaches(ID, course id, sec_id, semester, year) 
  course(course_id, title, dept_name, credits)
  
**************************************************************/
select name, course_id
from instructor, teaches
where instructor.ID = teaches.ID and instructor.dept_name = 'Comp. Sci.'


/**************************************************************
  Find the names of all instructors in the Comp. Sci. department 
  who have taught some course and the course_id
  Instructor(ID, name, dept_name, salary)
  teaches(ID, course id, sec_id, semester, year) 
  course(course_id, title, dept_name, credits)
  key note: rename (as)
**************************************************************/
select name as instructor_name, course_id
from instructor, teaches
where instructor.ID = teaches.ID

/**************************************************************
  Find the names of all instructors in the Comp. Sci. department 
  who have taught some course and the course_id  
  Instructor(ID, name, dept_name, salary)
  teaches(ID, course id, sec_id, semester, year) 
  course(course_id, title, dept_name, credits)
  key note: rename (as) - renamed relations 
**************************************************************/
select T.ID,name as instructor_name, course_id
from instructor as T, teachesas S
where T.ID = S.ID

/**************************************************************
  Find the names of all instructors who have a higher salary 
  than some instructor in 'Comp. Sci'.

  Instructor(ID, name, dept_name, salary) 
  Note: Renaming a relation is necessary when taking the Cartesian product 
		of a table with itself to distinguish between its instances.
**************************************************************/
select distinct t1.name
from instructor as t1 , instructor t2
where t2.dept_name = 'Comp. Sci.' and t1.salary > t2.salary;


-- set operations
--Find courses that ran in Fall 2017 or in Spring 2018
select course_id  from section where semester = 'Fall' and year = 2017           
union all
select course_id  from section where semester = 'Spring' and year = 2018

--Find courses that ran in Fall 2017 and in Spring 2018
select course_id  from section where semester = 'Fall' and year = 2017           
intersect      
select course_id  from section where semester = 'Spring' and year = 2018

--Find courses that ran in Fall 2017 but not in Spring 2018
select course_id  from section where semester = 'Fall' and year = 2017           
except       
select course_id  from section where semester = 'Spring' and year = 2018

/**************************************************************
  Review Terms

  Basic SQL Clauses
	- SELECT
	- DISTINCT
	- FROM
	- WHERE

  comp. operators 
	- <, <=, >, >=, =, and <>
  
  Logical Connectives
	- AND
	- OR
	- NOT

  Table & Column Aliases
	- AS

  Set Operations
	- UNION ALL
	- INTERSECT
	- EXCEPT
  
  Cartesian Product

**************************************************************/
