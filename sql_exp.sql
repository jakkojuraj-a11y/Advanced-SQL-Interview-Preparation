CREATE DATABASE SQL_7MOST;

USE SQL_7MOST;

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_name VARCHAR(50),
    sales_amount DECIMAL(10,2)
);
INSERT INTO sales VALUES
(1,'2023-01-10','Laptop',50000),
(2,'2023-02-15','Laptop',65000),
(3,'2023-03-20','Laptop',70000),
(4,'2023-04-25','Laptop',80000),
(5,'2024-01-05','Laptop',60000),
(6,'2024-02-18','Laptop',75000),
(7,'2024-03-12','Laptop',85000),
(8,'2024-04-22','Laptop',95000),
(9,'2023-01-15','Mouse',5000),
(10,'2024-01-20','Mouse',7000);


--  1: Calculate Month-over-Month (MoM) and Year-over-Year (YoY) Growth


-- Previous Month Sales

WITH monthly_sales AS ( SELECT DATE_FORMAT(sale_date,'%Y-%m') AS month, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY DATE_FORMAT(sale_date,'%Y-%m'))

SELECT month,Total_sales,LAG(total_sales) OVER(ORDER BY month) AS previous_month FROM monthly_sales;

-- Month-over-Month (MoM) Growth

WITH MONTHLY_SALES AS (SELECT DATE_FORMAT(SALE_DATE,'%Y-%m') as month, sum(sales_amount) as total_amount 
from sales group by DATE_FORMAT(SALE_DATE,'%Y-%m')),

growth as (Select month,total_amount, lag(total_amount) over(order by month) as previous_month from MONTHLY_SALES)


select month,total_amount, previous_month, round((total_amount - previous_month) / previous_month * 100,2) as monthly_precent
from growth;


-- only months where sales increased

WITH MONTHLY_SALES AS (SELECT DATE_FORMAT(SALE_DATE,'%Y-%m') as month, sum(sales_amount) as total_amount 
from sales group by DATE_FORMAT(SALE_DATE,'%Y-%m')),

growth as (Select month,total_amount, lag(total_amount) over(order by month) as previous_month from MONTHLY_SALES),


tot as (select month,total_amount, previous_month, round((total_amount - previous_month) / previous_month * 100,2) as monthly_precent
from growth)
select * from tot where total_amount > previous_month;

-- Year over year (YOY)

WITH YEARLY AS (SELECT YEAR(SALE_DATE) AS YEAR,SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM sales
GROUP BY YEAR(SALE_DATE)), 

GROWTH AS ( SELECT YEAR,TOTAL_SALES,LAG(TOTAL_SALES) OVER(ORDER BY YEAR) AS PREV_YEAR FROM YEARLY)

select * FROM GROWTH;

-- 

WITH YEARLY AS (SELECT YEAR(SALE_DATE) AS YEAR,SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM sales
GROUP BY YEAR(SALE_DATE)), 

GROWTH AS ( SELECT YEAR,TOTAL_SALES,LAG(TOTAL_SALES) OVER(ORDER BY YEAR) AS PREV_YEAR FROM YEARLY)

select YEAR,TOTAL_SALES,PREV_YEAR, ROUND((TOTAL_SALES - PREV_YEAR) / PREV_YEAR * 100,2) AS PERCENT FROM GROWTH;


-- 

WITH yearly AS (
    SELECT
        YEAR(sale_date) AS year,
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY YEAR(sale_date)
),
growth AS (
    SELECT
        year,
        total_sales,
        LAG(total_sales) OVER (ORDER BY year) AS prev_year
    FROM yearly
),
yoy AS (
    SELECT
        year,
        total_sales,
        prev_year,
        ROUND(((total_sales - prev_year) / prev_year) * 100, 2) AS yoy_growth
    FROM growth
)
SELECT *
FROM yoy
WHERE prev_year IS NOT NULL
  AND yoy_growth > 0;





CREATE TABLE product_sales (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(30),
    total_sales INT
);

INSERT INTO product_sales VALUES
(101,'iPhone','Mobile',500),
(102,'Samsung S24','Mobile',470),
(103,'OnePlus 12','Mobile',450),
(104,'Realme','Mobile',350),
(105,'Pixel','Mobile',300),

(201,'Dell','Laptop',600),
(202,'HP','Laptop',590),
(203,'Lenovo','Laptop',560),
(204,'Asus','Laptop',520),
(205,'Acer','Laptop',480),

(301,'Boat','Accessories',250),
(302,'JBL','Accessories',220),
(303,'Sony','Accessories',210),
(304,'Noise','Accessories',180);


-- Write a SQL query to find the Top 3 highest-selling products in each category using Window Functions.


CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(40),
    department VARCHAR(30),
    salary INT
);

INSERT INTO employees VALUES
(1,'Amit','HR',40000),
(2,'Priya','HR',45000),
(3,'Ravi','HR',45000),
(4,'Kiran','IT',60000),
(5,'Anita','IT',75000),
(6,'Rahul','IT',75000),
(7,'Sneha','Finance',50000),
(8,'Arjun','Finance',65000),
(9,'Pooja','Finance',70000);


-- Explain the differences between ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(), LEAD(), and LAG() with practical use cases.





CREATE TABLE customer_orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);


INSERT INTO customer_orders VALUES
(1,101,'2024-01-05',2500),
(2,102,'2024-01-12',3500),
(3,103,'2024-01-18',2000),
(4,101,'2024-02-10',5000),
(5,102,'2024-03-05',4200),
(6,104,'2024-03-18',6000),
(7,105,'2024-04-10',2800),
(8,101,'2024-04-22',7000),
(9,103,'2024-05-02',4500),
(10,106,'2024-05-20',3500);


-- Practice Question

-- Write SQL queries to calculate:

-- Total Customers
-- Returning Customers
-- Customer Retention Rate
-- Churn Rate


CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    order_date DATE,
    city VARCHAR(50),
    status VARCHAR(20)
);


INSERT INTO orders VALUES
(1,101,201,2,500,'2024-01-10','Hyderabad','Delivered'),
(2,102,202,1,900,'2024-01-12','Warangal','Delivered'),
(3,103,203,4,250,'2024-02-02','Hyderabad','Cancelled'),
(4,104,201,2,500,'2024-02-10','Delhi','Delivered'),
(5,105,204,1,1000,'2024-03-15','Mumbai','Delivered'),
(6,101,205,3,600,'2024-04-12','Hyderabad','Pending'),
(7,106,203,2,250,'2024-05-20','Chennai','Delivered'),
(8,107,204,5,1000,'2024-06-10','Pune','Delivered');


-- Practice Question

-- Suppose this table contains 100 million records.

-- Explain how you would optimize a SQL query that currently takes 10+ minutes to execute.

-- Include topics like:

-- Indexes
-- Composite Index
-- Covering Index
-- EXPLAIN Plan
-- Partitioning
-- Filtering Early
-- Avoid SELECT *
-- Joins
-- CTE vs Subquery
-- Materialized View
-- Statistics


CREATE TABLE employee_sales (
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    sales INT
);

INSERT INTO employee_sales VALUES
(1,'Amit','Sales',80000),
(2,'Rahul','Sales',90000),
(3,'Kiran','Marketing',50000),
(4,'Anita','Marketing',65000),
(5,'Sneha','Finance',70000),
(6,'Arjun','Finance',55000);


-- Explain CTEs, Temporary Tables, Views, and Materialized Views. When would you use each?


CREATE TABLE transactions (
    transaction_id INT,
    customer_id INT,
    amount DECIMAL(10,2),
    transaction_date DATETIME
);


INSERT INTO transactions VALUES
(1,101,500,'2024-01-01 10:00:00'),
(2,101,500,'2024-01-01 11:00:00'),
(3,102,700,'2024-01-02 09:00:00'),
(4,102,700,'2024-01-02 12:00:00'),
(5,103,900,'2024-01-03 08:00:00'),
(6,104,400,'2024-01-04 10:30:00'),
(7,104,400,'2024-01-04 11:15:00'),
(8,105,1000,'2024-01-05 09:45:00');

-- Write a SQL query to identify duplicate transactions while keeping only the latest record.


-- BONUS
-- Bonus Interview Questions
-- Find the second highest salary in each department.
-- Find customers who purchased in January but not in February.
-- Find products with sales greater than the category average.
-- Calculate a 3-month moving average of sales.
-- Find the top-selling product each month.
-- Find employees whose salary is higher than their department average.
-- Find consecutive days with sales.
-- Calculate cumulative revenue by month.
-- Find the first and last order of every customer.
-- Detect gaps in order dates using LAG().
-- Calculate each employee's salary as a percentage of the department total.
-- Find the top 5 customers by yearly revenue.
-- Rank cities by total sales.
-- Identify inactive customers (no purchases in the last 6 months).
-- Calculate repeat purchase frequency by customer.
