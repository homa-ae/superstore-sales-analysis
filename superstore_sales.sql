-- Superstore Sales Analysis

-- 1. Category Sales & Order Summary
SELECT 
	Category, ROUND(SUM(sales), 2) AS total_sales,
	COUNT("order id") AS total_orders,
	ROUND(AVG(sales), 2) AS average_sales
FROM sales
GROUP BY Category
ORDER BY total_sales DESC;


-- 2. Top 10 Customers by Total Spend
SELECT 
	"Customer ID", 
	"customer Name", 
	Segment,
	ROUND(SUM(sales),2) AS total_spent
FROM sales
GROUP BY "Customer ID"
ORDER BY total_spent DESC
LIMIT 10;


-- 3. Top 3 Sub-Categories per Region (Window Function)
WITH regional_sales AS(
SELECT 
	Region,
	"Sub-Category",
	ROUND(SUM(sales), 2) as total_sales,
	ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank
FROM sales
GROUP BY "Sub-Category", Region
)
SELECT
	Region,
	"Sub-Category",
	total_sales,
	rank
FROM regional_sales
WHERE rank <= 3
ORDER BY Region, rank;


-- 4. Customer Segmentation by Spending (CASE WHEN)
SELECT 
	"Customer ID", 
	"Customer Name",
	ROUND(SUM(sales), 2) AS total_sales,
	CASE
	WHEN SUM(sales)> 5000 THEN 'High Value' 
	WHEN SUM(sales) BETWEEN 1000 AND 5000 THEN 'Medium Value'
	ELSE 'Low Value'
	END AS Customer_Segment
FROM sales
GROUP BY "Customer ID", "Customer Name"


-- 5. Monthly Sales Trend
SELECT 
    SUBSTR("Order Date", 7, 4) || '-' || SUBSTR("Order Date", 4, 2) AS year_month,
    ROUND(SUM(Sales), 2) AS monthly_sales,
    COUNT("Order ID") AS monthly_orders
FROM sales
WHERE "Order Date" IS NOT NULL AND "Order Date" != ''
GROUP BY year_month
ORDER BY year_month ASC;




