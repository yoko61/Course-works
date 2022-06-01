
-- Write a query to retrieve all columns from the Enrollment table where the grade of A or B was assigned.
SELECT *
FROM Enrollment
where grade in ('A','B')

-- Write a query to return the first and last names of each student who has taken Geometry.
SELECT Student.first_name, Student.last_name
FROM  Enrollment
 INNER JOIN Student on Enrollment.Student_id =Student.Student_id
WHERE Class_id='101'

-- Write a query to return all rows from the Enrollment table where the student has not been given a failing grade (F).  Include any rows where the grade has not yet been assigned.
SELECT *
FROM Enrollment
where COALESCE(grade,'x') not in ('F')

-- Write a query to return the first and last names of every student in the Student table. If a student has ever enrolled in English, please specify the grade that they received.  
-- You need only include the Enrollment and Student tables and may specify the class_id value of 102 for the English class. 
-- The query should return one row for each student (4 rows) with nulls as grades for students who don't have a grade.
SELECT Student.first_name, Student.last_name, Enrollment.grade
FROM  Student
 left JOIN Enrollment on Enrollment.Student_id =Student.Student_id
WHERE Class_id='102'

-- Write a query to return the class names and the total number of students who have ever been enrolled in each class. If a student has enrolled in the same class twice, it is OK to count him twice in your results.
SELECT Class.class_name, COUNT(*)
FROM Class
 INNER JOIN Enrollment on Enrollment.class_id=Class.class_id
GROUP BY class_name

-- Write a statement to update Robert Smith’s grade for the English class from a B to a B+.  Specify the student by his student ID, which is 500, and the English class by class ID 102.
SELECT *
FROM Enrollment
WHERE student_id=500 AND class_id=102;

UPDATE Enrollment.grade
SET grade='B+'
WHERE student_id=500 AND class_id=102;

-- Create an alternate statement to update Robert Smith’s grade in English to a B+, but for this version specify the student by first/last name, not by student ID.  This will require the use of a subquery.
SELECT Student.first_name, Student.last_name, Enrollment.class_id, Enrollment.grade
FROM  Enrollment
 INNER JOIN Student on Enrollment.Student_id =Student.Student_id
 WHERE first_name='Robert' AND last_name='Smith' AND class_id='102';
 
UPDATE Enrollment
SET grade='B+'
 WHERE first_name='Robert' AND last_name='Smith' AND class_id='102';

-- A new student name Michael Cronin enrolls in the Geometry class.  Construct a statement to add the new student to the Student table. (You can pick any value for the student_id, provided it doesn’t already exist in the table).
INSERT INTO Student( student_id, first_name, last_name)
VALUE ('300', 'Michael', 'Cronin');
SELECT student_id, first_name, last_name
FROM Student

-- Add Michael Cronin’s enrollment in the Geometry class to the Enrollment table.  You may only specify names (e.g. “Michael”, “Cronin”, “Geometry”) and not numbers (e.g. student_id, class_num) in your statement.  
-- You may use subqueries if desired, but the statement can also be written without the use of subqueries. Use ‘Spring 2020’ for the semester value.

-- INSERT INTO Student( student_id, first_name, last_name)
-- VALUE ('300', 'Michael', 'Cronin');
INSERT INTO Enrollment(class_id, student_id, semester)
SELECT  class_id, student_id, 'Spring 2020'
FROM Student cross join Class
where first_name='Michael' AND last_name='Cronin' AND class_name='geometry'

-- Write a query to return the first and last names of all students who have not enrolled in any class. It is important to use a correlated subquery for this question. Please DO NOT use a JOIN.
SELECT Student.first_name, Student.last_name
FROM Student 
WHERE student_id not in (
	SELECT student_id FROM Enrollment where student_id = Student.student_id
)

-- Return the same results as the previous question (first and last name of all students who have not enrolled in any class), but formulate your query using a non-correlated subquery. 
--It is important to use a non-correlated subquery for this question. Please DO NOT use a JOIN.
SELECT Student.first_name, Student.last_name
FROM Student 
WHERE student_id not in (
	SELECT student_id FROM Enrollment)

-- Write a statement to remove any rows from the Student table where the person has not enrolled in any classes.  You may use either a correlated or non-correlated subquery. Please DO NOT use a JOIN.
DELETE FROM Student 
WHERE student_id not in (
	SELECT student_id FROM Enrollment)
	
	
-- Write a query to retrieve each unique customer ID (cust_id) from the Customer_Order table.  There are multiple ways to construct the query, but do not use a subquery.
SELECT DISTINCT cust_id
FROM Customer_Order

-- Write a query to retrieve each unique customer ID (cust_id) along with the latest order date for each customer.  Do not use a subquery.
SELECT cust_id, max(order_date)
FROM Customer_Order
GROUP BY cust_id


-- Write a query to retrieve all rows and columns from the Customer_Order table, with the results sorted by order date descending (latest date first) and then by customer ID ascending.
SELECT *
FROM Customer_Order
order by order_date DESC, cust_id

-- Write a query to retrieve each unique customer (cust_id) whose lowest order number (order_num) is at least 3.  Please note that this is referring to the value of the lowest order number and NOT the order count.  
--Do not use a subquery.
SELECT cust_id, min(order_num)
FROM Customer_Order
GROUP BY cust_id
HAVING min(order_num)>3

-- Write a query to retrieve only those customers who had 2 or more orders on the same day.  Retrieve the cust_id and order_date values, along with the total number of orders on that date.  Do not use a subquery.
SELECT cust_id, order_date, COUNT(*)
FROM Customer_Order
GROUP BY cust_id, order_date
HAVING COUNT(*)>2

-- Along with the Customer_Order table, there is another Customer table below. Write a query that returns the name of each customer who has placed exactly 3 orders.  
--Do not return the same customer name more than once, and use a correlated subquery (no JOINS please) against Customer_Order to determine the total number of orders for each customer:
SELECT Customer.cust_name
FROM Customer
WHERE cust_id in (
	SELECT cust_id 
	from customer_order 
	where cust_id=customer.cust_id
	group by cust_id 
	having COUNT(*)=3
)

-- Construct a different query to return the same data as the previous question (name of each customer who has placed exactly 3 orders) but use a non-correlated subquery (no JOINS please) against the Customer_Order table. It is important to code a non-correlated subquery for this question.
SELECT Customer.cust_name
FROM Customer
WHERE cust_id in (
	SELECT cust_id 
	from customer_order 
	group by cust_id 
	having COUNT(*)=3
)

-- Write a query to return the name of each customer, along with the total number of orders for each customer.  
-- Include all customers, regardless if they have orders or not. Use a scalar, correlated subquery (no JOINS please) to generate the number of orders.
SELECT 
	Customer.cust_name, 
	(
	SELECT COUNT(*)
	from customer_order 
	where cust_id=customer.cust_id
	group by cust_id 
	) orders

FROM Customer
