# **Assignment 1: Database Schema and DDL Operations**

## **Objective**

In this assignment, you will implement **SQL Data Definition Language (DDL) operations** for a **pre-designed database schema** in **SQL Server**. The goal is to create and modify database tables while ensuring proper constraints and relationships.

## **Instructions**

1. **Create the Database and Tables**
   - Define a database named `Insurance`.
   - Create the following tables with appropriate data types and constraints:
     - person (<u>driver_id</u>, name, address)
     - car (<u>license_plate</u>, model, year)
     - accident (<u>report_number</u>, year, location)
     - owns (<u>driver_id</u>, <u>license_plate</u>)
     - participated (<u>report_number</u>, <u>license_plate</u>, driver_id, damage_amount)
1. **Alter a Table**
   - Modify an existing table by adding a new column (`phone_number` in the `person` table).
   - Ensure the new column is **unique** and cannot be NULL.

## **Submission Guidelines**

- Your **SQL script** must begin with a comment containing your **name and student ID** as follows:

```sql
   -- Student Name: [Your Name]
   -- Student ID: [Your ID]
```

- Save the file with your **student name** as the filename (e.g., `John_Doe.sql`).
- Submit your SQL script as a **.sql file** [here](https://forms.gle/khKvRGhh48rAZNEKA) by **29/3/2025**.
