-- ============================================
-- SQL Sales Analysis - Online Retail Dataset
-- ============================================

-- 1. Data Cleaning
CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail
WHERE CustomerID IS NOT NULL
AND Quantity > 0
AND UnitPrice > 0;

-- 2. Total Revenue
SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_clean;

-- 3. Total Unique Orders
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_clean;

-- 4. Total Unique Customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM online_retail_clean;

-- 5. Top 10 Products by Quantity
SELECT Description, 
       SUM(Quantity) AS total_quantity
FROM online_retail_clean
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;

-- 6. Top 10 Countries by Revenue
SELECT Country,
       ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_clean
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

-- 7. Monthly Revenue
WITH monthly_sales AS (
    SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS month,
           ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
    FROM online_retail_clean
    GROUP BY month
)
SELECT month, revenue
FROM monthly_sales
ORDER BY month;

-- 8. Customers Above Average Spending
SELECT CustomerID,
       ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent
FROM online_retail_clean
GROUP BY CustomerID
HAVING total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT CustomerID,
               SUM(Quantity * UnitPrice) AS total_spent
        FROM online_retail_clean
        GROUP BY CustomerID
    ) AS customer_totals
)
ORDER BY total_spent DESC;

-- 9. Top Product per Country
WITH country_product_revenue AS (
    SELECT Country, Description,
           ROUND(SUM(Quantity * UnitPrice), 2) AS revenue,
           RANK() OVER (PARTITION BY Country ORDER BY SUM(Quantity * UnitPrice) DESC) AS country_rank
    FROM online_retail_clean
    GROUP BY Country, Description
)
SELECT Country, Description, revenue
FROM country_product_revenue
WHERE country_rank = 1
ORDER BY revenue DESC;

-- 10. First Order per Customer
WITH first_orders AS (
    SELECT CustomerID, InvoiceNo, InvoiceDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS rn
    FROM online_retail_clean
)
SELECT CustomerID, InvoiceNo, InvoiceDate
FROM first_orders
WHERE rn = 1;

-- 11. Monthly Revenue vs Previous Month
WITH monthly_sales AS (
    SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS month,
           ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
    FROM online_retail_clean
    GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS difference
FROM monthly_sales
ORDER BY month;

-- 12. Running Total
WITH monthly_sales AS (
    SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS month,
           ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
    FROM online_retail_clean
    GROUP BY month
)
SELECT month, revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total
FROM monthly_sales
ORDER BY month;

-- 13. Customer Segmentation
WITH customer_spending AS (
    SELECT CustomerID,
           ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent
    FROM online_retail_clean
    GROUP BY CustomerID
)
SELECT CustomerID, total_spent,
       CASE
           WHEN total_spent > 10000 THEN 'High'
           WHEN total_spent > 1000 THEN 'Medium'
           ELSE 'Low'
       END AS customer_category
FROM customer_spending
ORDER BY total_spent DESC;
