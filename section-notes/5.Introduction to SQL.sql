USE university;
CREATE TABLE department_test (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50),
    budget DECIMAL(10,2)
);

-- some dummy tuples for testing
INSERT INTO department_test (dept_name, building, budget) VALUES 
('Computer Science', 'Watson Hall', 90000.00),
('Mathematics', 'Main Building', 75000.00),
('Physics', 'Watson Science Center', 80000.00),
('Biology', 'Life Sciences', 65000.00),
('Chemistry', 'Chem Lab', 70000.00),
('Mechanical Engineering', 'MEC', 85000.00),
('Electrical Engineering', 'ECE Block', 88000.00),
('Civil Engineering', 'CIV Block', 82000.00),
('Computational Biology', 'Comp Bio Lab', 77000.00),
('Data Science', 'Comp Sci Center', 92000.00),
('History', 'Humanities Hall', 68000.00),
('Philosophy', 'Arts Building', 66000.00),
('Business', 'Business Tower', 93000.00),
('Economics', 'ECO Block', 71000.00),
('CS', 'Watson Computer Science Center', 80000.00),
('Joe Computer Science', 'Joe Watson Hall', 90000.00),
('Math', 'test_ab%cd\test', 90000.00)
select * from department_test
INSERT INTO department_test (dept_name, building, budget) VALUES ('Test', 'test_ab%cd\test', null);

Insert into instructor (id, name , dept_name) values ('12345', 'Alice', 'Physics')
Insert into instructor (id, name , dept_name, salary) values ('12346', 'Bob', 'Comp. Sci.', null)
select * from instructor
delete from instructor where id = '12347'

/**************************************************************
  Chapter 3 cont. ( string operations - null value - aggregation functions - aggregation with grouping )
  Works for microsoft sql server
**************************************************************/

--3.4.2 String Operations
/**************************************************************
  Query: Find instructors in physics department.
  Instructor(ID, name, dept_name, salary)
  
  The SQL standard requires case-sensitive string comparisons.
	'comp. sci.' = 'Comp. Sci.' -> FALSE
  However, MySQL and SQL Server perform case-insensitive string comparisons by default.
	'comp. sci.' = 'Comp. Sci.' -> TRUE
**************************************************************/
select * from instructor where dept_name = 'physIcs'


--Pattern Matching with `LIKE`
/**************************************************************
  Query: Find departments whose building name starts with 'Watson' 
		 schema: department(dept_name, building, budget) 

  SQL allows pattern matching using the `LIKE` operator with two special characters:  
	`%` (percent sign) -> Matches any substring.  
	`_` (underscore)   -> Matches exactly one character.  
**************************************************************/
SELECT *  
FROM department_test 
where building like 'watson%'

/**************************************************************
  Query: Find departments whose building name ends with 'hall' 
		 schema: department(dept_name, building, budget) 
**************************************************************/
SELECT *  
FROM department_test 
where building like '%hall'

/**************************************************************
  Query: Find departments where the building name contains 'Comp' anywhere
		 schema: department(dept_name, building, budget)   
**************************************************************/
SELECT *  
FROM department_test 
where building like '%comp%';

/**************************************************************
  Query: Find departments where the building name has exactly 3 characters
		 schema: department(dept_name, building, budget)  
**************************************************************/
select * from department_test 
WHERE building LIKE '___';

/**************************************************************
  Query: Find departments where the building name is at least 4 characters long
		 schema: department(dept_name, building, budget)  
**************************************************************/
select * 
from department_test 
WHERE building LIKE '____%';

/**************************************************************
  Query: Find departments where the building name contains 'ab%cd' (treating `%` as a normal character)
		 schema: department(dept_name, building, budget)
  note:  you can define any char as escape char   %\_ab\%cd\\test
**************************************************************/
select * 
from department_test
where building like '%ab\%cd%' escape '\'

/**************************************************************
  Query: Find departments where the building name does NOT contain 'Watson'
		 schema: department(dept_name, building, budget)  
**************************************************************/ 
SELECT *  
FROM department_test  
WHERE building NOT LIKE '%Watson%';  

--3.4.4 Ordering the Display of Tuples
/**************************************************************
  Query: List all instructors in the Physics department in alphabetical order ascending ( A -> Z )
		 schema: department(dept_name, building, budget)
		   
  SQL allows sorting query results using the `ORDER BY` clause
  - By default, sorting is ascending `ASC`.  
  - Use `DESC` for descending order.  
  - Multiple columns can be used for sorting.
**************************************************************/
select *
from instructor
where dept_name = 'Physics'
order by name desc

/**************************************************************
  Query: List all instructors in descending order of salary ( Highest salary first )
		 schema: department(dept_name, building, budget)

		 -> If multiple instructors have the same salary, sort by name (ascending)
**************************************************************/
SELECT *  
FROM instructor  
ORDER BY salary DESC, name asc;


--3.4.5 Where-Clause Predicates ( between )
/**************************************************************
  Query: Find instructors with salaries between $70000 and $90000 (end points included)
		 schema: Instructor(ID, name, dept_name, salary)

  
  -`BETWEEN` Operator
	- use `BETWEEN` Instead of using `<=` and `>=`, the  operator.
	- BETWEEN makes SQL queries easier to read and write.
	- It avoids repeating the column name in range conditions.
	- While it doesn’t improve performance, it makes code clearer.
**************************************************************/
SELECT name  
FROM instructor  
WHERE salary BETWEEN 70000 AND 90000;

SELECT name  
FROM instructor  
WHERE salary >= 70000 AND salary <= 90000;

/**************************************************************
  Query: Find instructors with salaries not between $70000 and $90000 (end points included)
		 schema: Instructor(ID, name, dept_name, salary)
**************************************************************/
SELECT name  
FROM instructor  
WHERE salary not BETWEEN 70000 AND 90000;

SELECT name  
FROM instructor  
WHERE not (salary >= 70000 AND salary <= 90000);


--3.6 Null Values
/**************************************************************
  Query: Add 5000 to each instructor's salary
		 schema: Instructor(ID, name, dept_name, salary)

  - null present special problems in relational operations, including arithmetic operations, comparison operations, and set operations.
  - Arithmetic: The result of an arithmetic expression (involving, for example, +, −, ∗, or ∕) is null if any of the input values is null.
**************************************************************/
SELECT name, salary, salary + 5000 AS new_salary
FROM instructor;


/**************************************************************
  NULL in Comparisons:  
   - Comparisons involving nulls are more of a problem. For example, consider the 
     comparison “1 < null”. It would be wrong to say this is true since we do not know
	 what the null value represents. But it would likewise be wrong to claim this expression
	 is false; if we did, “not (1 < null)” would evaluate to true, which does not make sense.
   - SQL therefore treats as unknown the result of any comparison involving a null value (other than predicates is null and is not null)
   - `NULL = NULL` does not return `TRUE`, it returns UNKNOWN.  

  Boolean Operations with NULL: 
   - SQL extends Boolean logic to handle UNKNOWN values.  
   - AND:
     - `TRUE AND UNKNOWN` -> UNKNOWN  
     - `FALSE AND UNKNOWN` -> FALSE  
     - `UNKNOWN AND UNKNOWN` -> UNKNOWN  
   - OR:  
     - `TRUE OR UNKNOWN` -> TRUE  
     - `FALSE OR UNKNOWN` -> UNKNOWN  
     - `UNKNOWN OR UNKNOWN` -> UNKNOWN  
   - NOT:  
     - `NOT UNKNOWN` -> UNKNOWN  
 
   - If a `WHERE` condition evaluates to FALSE or UNKNOWN, the row is excluded from the result.  

     SELECT * FROM instructor WHERE salary > 60000;   the or <=60000

	 Query: Find instructors with a salary greater than 10000
		schema: Instructor(ID, name, dept_name, salary)

**************************************************************/
SELECT name, salary 
FROM instructor 
WHERE salary > 60000 or salary <= 60000;

/**************************************************************
  Query:Find instructors with salary equal to NULL
	schema: Instructor(ID, name, dept_name, salary)

  note: SQL uses the special keyword null in a predicate to test for a null value (is null , is not null)
**************************************************************/
SELECT name, salary 
FROM instructor 
WHERE salary = NULL; -- would return unknown for every tuple????

SELECT name, salary 
FROM instructor 
WHERE salary is null;

/**************************************************************
  Query:Find instructors with not null salary 
	schema: Instructor(ID, name, dept_name, salary)

  note: SQL uses the special keyword null in a predicate to test for a null value (is null , is not null)
**************************************************************/
SELECT name, salary 
FROM instructor 
WHERE salary is not null;

/**************************************************************
  Query: To satisfy all condition ( What a silly query! )
	schema: Instructor(ID, name, dept_name, salary)

  note: SQL uses the special keyword null in a predicate to test for a null value (is null , is not null)
**************************************************************/
select * from instructor where salary > 60000 or salary <= 60000 or salary is null
select * from instructor where salary is null or salary is not null

/**************************************************************
  Query: Checking Distinct Salaries 
	schema: Instructor(ID, name, dept_name, salary)
  - NULL with DISTINCT
**************************************************************/
SELECT DISTINCT salary
FROM instructor;

--3.7 Aggregate functions
/**************************************************************
  Aggregate functions are functions that take a collection (a set or multiset) 
  of values as input and return a single value. 
	• Average: avg
	• Minimum: min
	• Maximum: max
	• Total: sum
	• Count: count
  - Note: The input to sum and avg must be a collection of numbers, but the other operators can operate on collections of nonnumeric data types, such as strings, as well.
**************************************************************/

/**************************************************************
  query: Find the average salary of all instructors
**************************************************************/
select avg(salary) 
from instructor

/**************************************************************
  query: Find the average salary of instructors in the Computer Science department
  note: rename result column to avg_salary
**************************************************************/
select avg(salary) avg_salary
from instructor
where dept_name = 'Comp. Sci.'

/**************************************************************
  query: Find the total number of instructors who teach a course in the Spring 2018 semester.
  hint: should we romeve duplicate values
**************************************************************/
SELECT COUNT(distinct id) as n_instructor
FROM teaches 
WHERE semester = 'Spring' AND year = 2018;

/**************************************************************
  query: Counting All Rows in a Table
  note: distinct column_name is allowed while ditinct * is not allowed
**************************************************************/
SELECT COUNT(*) 
FROM course;

/**************************************************************
  query: Find the highest, lowest, and total salaries
  note: you can use distinct with max, min, sum but it doesn't matter for max and min;

**************************************************************/
SELECT MAX(dept_name) AS highest_salary, 
       MIN(salary) AS lowest_salary, 
       SUM(salary) AS total_salary
FROM instructor 

--3.7.4 Aggregation with Null 
/**************************************************************
  note: All aggregate functions except count (*) ignore null values in their input collection.
  
**************************************************************/
SELECT COUNT(*) AS total_rows, COUNT(salary) AS non_null_salaries_count 
FROM instructor;

-- 3.7.2 Aggregation with Grouping
/**************************************************************
  query: Find the average salary in each department
  
  `GROUP BY` Clause
	- Used to divide data into groups based on one or more columns.
	- Each group has the same values for the specified columns.
	- Aggregate functions (e.g., `AVG()`, `COUNT()`) are applied to each group.

	follow up: can we remove dept_name from the select clause
**************************************************************/
SELECT dept_name, AVG(salary) AS avg_salary -- Any column in the SELECT clause must either be inside an aggregate function  (e.g., AVG, COUNT, SUM) or be listed in the GROUP BY clause ( start thinking from group by - the real thing is you can't select any attributes that is not in the group by except the aggregation function as it will be calculated for each group
FROM instructor
GROUP BY dept_name;

/**************************************************************
  query: Find the average salary of all instructors
  note: In case the `group by` clause is omitted, the entire relation is treated as a single group.
**************************************************************/
SELECT AVG(salary) as avg_salary
FROM instructor;

/**************************************************************
  query: Find the number of instructors in each department who taught a course in the Spring 2018 semester.

  how the following query works
	- The `instructor` and `teaches` tables are joined on `ID`.  
	- The `WHERE` clause filters only Spring 2018 courses.  
	- `GROUP BY dept_name` ensures the count is computed per department.  
	- `COUNT(DISTINCT instructor.ID)` ensures that each instructor is counted only once as there exists instuctors that teaches more than 1 course.  
**************************************************************/
select count(distinct id) from teaches where teaches.semester = 'spring' and teaches.year = 2018 -- Explain first

select dept_name ,count(distinct name)
from instructor, teaches
where instructor.id = teaches.id and teaches.semester = 'spring' and teaches.year = 2018
group by dept_name

/**************************************************************
  query: Find departments where the average salary is more than $42,000.

  HAVING Clause (Filtering Groups)
    - `HAVING` is used to filter groups after aggregation.
	- `WHERE` filters individual rows, but `HAVING` filters entire groups.

  SQL processes queries in a specific order:  
	1. `FROM`     – Specifies the table to retrieve data from.  
	2. `WHERE`    – Filters rows before aggregation.  
	3. `GROUP BY` – Groups rows and computes aggregates (AVG(salary), COUNT(*), etc.).  
	4. `HAVING`   – Filters groups after aggregation.  
	5. `SELECT`   – Selects the columns and calculates expressions, including aliases.
	6. `ORDER BY` - Sorts the final result  
**************************************************************/
SELECT dept_name, AVG(salary) AS avg_salary
FROM instructor
GROUP BY dept_name
HAVING avg(salary) > 40000; -- can't be avg_salary > 42000

/**************************************************************
  query: For each course section offered in 2017, find the average total credits (tot cred) of all students enrolled in the section, if the section has at least 2 students.

  how the following query works 
	1. `WHERE year = 2017` → Selects only records from 2017.  
	2. `GROUP BY course_id, semester, year, sec_id` → Groups by section.
	3. `AVG(tot_cred)` → Computes average credits for each section.  
	4. `HAVING COUNT(student.id) >= 2` → Keeps only sections with at least 2 students.  
**************************************************************/
SELECT course_id, semester, year, sec_id, AVG(tot_cred)
FROM student, takes
WHERE student.ID = takes.ID AND year = 2017
GROUP BY course_id, semester, year, sec_id
HAVING COUNT(student.id) >= 2;

