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

-- BONUS
-- Bonus Interview Questions
-- Find the second highest salary in each department.
Select * from emp;
select max(salary) as second_highest_salary from emp where salary < (SELECT MAX(SALARY) AS second_highest_salary FROM EMP );

-- Find customers who purchased in January but not in February.

select * from ord;

select o1.customer_id from ord o1
where month(o1.order_date) = 1
and not exists(
select 1 from ord o2 
where o1.customer_id = o2.customer_id
and month(o2.order_date) = 2); 

-- Find products with sales greater than the category average.

select * from product_sales;

WITH category_avg AS (
    SELECT category,
           AVG(total_sales) AS avg_sales
    FROM product_sales
    GROUP BY category
)

SELECT p.product_name,
       p.category,
       p.total_sales
FROM product_sales p
JOIN category_avg c
ON p.category = c.category
WHERE p.total_sales > c.avg_sales;


SELECT product_name, category, total_sales From Product_sales p 
where total_sales > (
select avg(a.total_sales) from product_sales a 
where p.category = a.category);

-- Calculate a 3-month moving average of sales.

SELECT * FROM ORD;

WITH MONTHLY AS (SELECT DATE_FORMAT(ORDER_DATE,'%Y-%m') as month,sum(QUANTITY * price) AS SALES FROM ORD
group by DATE_FORMAT(ORDER_DATE,'%Y,%m')
)

SELECT MONTH,SALES,ROUND(AVG(SALES) OVER(ORDER BY MONTH 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
),2) AS _MOVING_SALES FROM MONTHLY;


-- Find the top-selling product each month.

WITH SALE AS (SELECT product_id,DATE_FORMAT(ORDER_DATE,'%Y-%m') as Month,sum(quantity * price) as Total_Sales
From ord
GROUP BY product_id,DATE_FORMAT(ORDER_DATE,'%Y-%m')),

TOP AS (SELECT *,dense_rank() OVER(partition by MONTH ORDER BY TOTAL_SALES DESC) AS TOP FROM sale)

SELECT * FROM TOP WHERE TOP = 1;


-- Find employees whose salary is higher than their department average.

SELECT * FROM EMP;

SELECT EMP_NAME,DEPARTMENT,SALARY FROM EMP E
WHERE SALARY > (SELECT AVG(D.SALARY) FROM EMP D WHERE E.DEPARTMENT = D.DEPARTMENT);


-- Find consecutive days with sales.

WITH ODD AS (SELECT distinct ORDER_DATE FROM ORD),
consecutive AS (SELECT ORDER_DATE ,LAG(ORDER_DATE) OVER(order by ORDER_DATE) AS PREV FROM ODD)
SELECT * FROM consecutive
WHERE datediff(ORDER_DATE,PREV) = 1;

WITH sales_days AS (
    SELECT DISTINCT order_date
    FROM ord
),
consecutive AS (
    SELECT
        order_date,
        LAG(order_date) OVER (ORDER BY order_date) AS previous_day
    FROM sales_days
)

SELECT *
FROM consecutive
WHERE DATEDIFF(order_date, previous_day) = 1;



-- Calculate cumulative revenue by month.

with mon as (SELECT DATE_FORMAT(ORDER_DATE,'%Y-%m') as Month, sum(quantity * price) as total_sales from ord group by DATE_FORMAT(ORDER_DATE,'%Y-%m'))
select month,sum(total_sales) over(order by month) as cumulative from mon;


-- Find the first and last order of every customer.

WITH orders_rank AS (
    SELECT customer_id,order_id,order_date, row_number() OVER( PARTITION BY customer_id order by ORDER_DATE) AS FIRST, row_number() OVER(PARTITION BY customer_id order by ORDER_DATE  DESC) AS LAST from ord )
    select * from orders_rank where first = 1 or last = 1;
        

-- Detect gaps in order dates using LAG().

with gap as (SELECT ORDER_DATE,lag(order_date) over (order by ORDER_DATE)as prev_days from ord)
select order_date,prev_days,datediff(order_date,prev_days) as day_gaps from gap 
where datediff(order_date,prev_days) > 1;


-- Calculate each employee's salary as a percentage of the department total.

SELECT * FROM EMP;

SELECT emp_id,emp_name,department,salary,ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY department),2) AS percentage FROM emp;


-- Find the top 5 customers by yearly revenue.

with top as (SELECT CUSTOMER_ID,YEAR(ORDER_DATE) AS YEAR,SUM(QUANTITY * PRICE) as total_revenue,dense_rank() over(partition by YEAR(ORDER_DATE)
 order by SUM(QUANTITY * PRICE) desc) as rank1 from ord
 group by CUSTOMER_ID,YEAR(ORDER_DATE))
 
 select * from top where rank1 <= 5;



-- Rank cities by total sales.

select * from ord;

select city,sum(quantity * price) as total_sales,dense_rank() over(order by sum(quantity * price) desc) as Rankings from ord
group by city;



-- Identify inactive customers (no purchases in the last 6 months).
WITH IN_ACTIVE AS (
SELECT CUSTOMER_ID,MAX(ORDER_DATE) AS LAST_DATE FROM ORD
GROUP BY CUSTOMER_ID)

SELECT CUSTOMER_ID,LAST_DATE FROM IN_ACTIVE
WHERE LAST_DATE < date_sub(curdate(),INTERVAL 6 MONTH);



-- Calculate repeat purchase frequency by customer.

SELECT CUSTOMER_ID,COUNT(ORDER_ID) FROM ORD
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) > 1;


SELECT
    ROUND(
        COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM ord
    GROUP BY customer_id
) t;
