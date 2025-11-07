/*
==================================================================================
Magnitude Analysis 
==================================================================================
Script Purpose:
	This script performs aggregations by various dimensions in each table.
	It provides key insight into the magnitude of each category in a dimension.
==================================================================================
*/
-- Which country populates our highest number of customers?
SELECT
country,
COUNT(customer_key) total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Are most of our customers males?
SELECT
gender,
COUNT(customer_key) total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Are most of our customers married?
SELECT
marital_status,
COUNT(customer_key) total_customers
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY total_customers DESC;

-- Which countries contribute most to our overall sales and order volume?
SELECT
c.country,
COUNT(DISTINCT s.customer_key) total_customers,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.sales_amount) total_sales,
SUM(s.quantity) total_quantity,
AVG(s.price) avg_selling_price,
AVG(p.product_cost) avg_product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY c.country
ORDER BY total_sales DESC;

-- Which gender seems to gravitate towards our products by measure of total orders, sales, and quantity?
SELECT
c.gender,
COUNT(DISTINCT s.customer_key) total_customers,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.sales_amount) total_sales,
SUM(s.quantity) total_quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_sales DESC;

-- Do married customers generate more revenue than single customers?
SELECT
c.marital_status,
COUNT(DISTINCT s.customer_key) total_customers,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.sales_amount) total_sales,
SUM(s.quantity) total_quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.marital_status
ORDER BY total_sales DESC;

-- Which customer brings in the most revenue
SELECT
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.sales_amount) total_sales,
SUM(s.quantity) total_quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_sales DESC;

-- Which product line contain the most amount of products?
SELECT
product_line,
COUNT(product_key) total_products
FROM gold.dim_products
GROUP BY product_line 
ORDER BY total_products DESC;

-- What category of product line has the highest number of products?
SELECT
product_line,
category,
COUNT(product_key) total_products
FROM gold.dim_products
GROUP BY product_line, category 
ORDER BY product_line, total_products DESC; 

-- Is the total revenue evenly distributed across all product line?
SELECT
p.product_line,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.quantity) total_quantity,
SUM(s.sales_amount) total_sales,
AVG(s.price) avg_selling_price,
AVG(p.product_cost) avg_product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_line
ORDER BY product_line, total_sales DESC;

-- Which category of product line generates the highest revenue, and is it driven by price, or demand, or both?
SELECT
p.product_line,
p.category,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.quantity) total_quantity,
SUM(s.sales_amount) total_sales,
AVG(s.price) avg_selling_price,
AVG(p.product_cost) avg_product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_line, p.category
ORDER BY product_line, total_sales DESC; 

-- Which subcategory within each category and product line generates the highest revenue?
SELECT
p.product_line,
p.category,
p.subcategory,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.quantity) total_quantity,
SUM(s.sales_amount) total_sales,
AVG(s.price) avg_selling_price,
AVG(p.product_cost) avg_product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_line, p.category, p.subcategory
ORDER BY product_line, p.category, total_sales DESC;

-- Which product generates the highest revenue across all categories and product line?
SELECT
p.product_line,
p.category,
p.subcategory,
p.product_name,
COUNT(DISTINCT s.order_number) total_orders,
SUM(s.quantity) total_quantity,
SUM(s.sales_amount) total_sales,
AVG(s.price) avg_selling_price,
AVG(p.product_cost) avg_product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_line, p.category, p.subcategory, p.product_name
ORDER BY total_sales DESC;
