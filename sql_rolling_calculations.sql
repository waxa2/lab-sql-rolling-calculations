
use sakila;
-- 1. Get number of monthly active customers.
SELECT COUNT(DISTINCT(customer_id)) as amount_active_cust, LEFT(return_date,4) as active_month_year, MONTH(return_date) as month
FROM rental
GROUP BY active_month_year,month;

-- 2. Active users in the previous month.
SELECT COUNT(DISTINCT(customer_id)) as amount_active_cust, LEFT(return_date,4) as active_month_year, MONTH(return_date) as month, 
LAG(COUNT(DISTINCT(customer_id)),1) OVER () as previous_month_cust
FROM rental
GROUP BY active_month_year,month;

-- 3. Percentage change in the number of active customers.
SELECT ((amount_active_cust-previous_month_cust)/amount_active_cust)*100 as percentage_change
FROM(
SELECT COUNT(DISTINCT(customer_id)) as amount_active_cust, LEFT(return_date,4) as active_month_year, MONTH(return_date) as month, 
LAG(COUNT(DISTINCT(customer_id)),1) OVER () as previous_month_cust
FROM rental
GROUP BY active_month_year,month) as sub1;

-- 4. Retained customers every month.

SELECT COUNT(DISTINCT(customer_id)) as retained_customers, month,previous_month_cust
FROM(
SELECT customer_id, LEFT(return_date,4) as year, MONTH(return_date) as month,LAG(MONTH(return_date),1) OVER (PARTITION BY customer_id) as previous_month_cust
FROM rental
GROUP BY customer_id, year,month
ORDER BY customer_id ASC, year ASC, month ASC) sub1
GROUP BY previous_month_cust, month
HAVING month= previous_month_cust+1;


SELECT customer_id, LEFT(return_date,4) as year, MONTH(return_date) as month,LAG(MONTH(return_date),1) OVER (PARTITION BY customer_id) as previous_month_cust
FROM rental
GROUP BY customer_id, year,month
ORDER BY customer_id ASC, year ASC, month ASC


