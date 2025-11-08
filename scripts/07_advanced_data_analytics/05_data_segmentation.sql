/*
============================================================================================================
Data Segmentation
============================================================================================================
Script Purpose:
	This script categorizes customers based on their age group, loyalty, and revenue
	generated.
============================================================================================================
*/
-- How is the total number of customers distributed across various age groups?
SELECT
	age_group,
	COUNT(customer_key) total_customers
FROM
(
	SELECT
		customer_key,
		birth_date,
		DATEDIFF(year, birth_date, GETDATE()) age,
		CASE
			WHEN DATEDIFF(year, birth_date, GETDATE()) < 20 THEN 'Below 20'
			WHEN DATEDIFF(year, birth_date, GETDATE()) BETWEEN 20 AND 29 THEN '20-29'
			WHEN DATEDIFF(year, birth_date, GETDATE()) BETWEEN 30 AND 39 THEN '30-39'
			WHEN DATEDIFF(year, birth_date, GETDATE()) BETWEEN 40 AND 49 THEN '40-49'
			WHEN DATEDIFF(year, birth_date, GETDATE()) BETWEEN 50 AND 59 THEN '50-59'
			ELSE 'Above 59'
		END age_group
	FROM gold.dim_customers
	WHERE birth_date IS NOT NULL
)SUB
GROUP BY age_group
ORDER BY total_customers DESC;

/* Categorize our customers into 'VIP', 'Regular', and ' New' based on the following criteria:
	* VIP: At least 12 months of history with the organization, and total spend above 5000.
	* Regular: At least 12 months of history with the organization, and total spend less than equal to 5000.
	* New: Less than 12 months of history.
*/
SELECT
	customer_status,
	COUNT(customer_key) total_customers
FROM
(
	SELECT
		customer_key,
		CASE
			WHEN life_span_month >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN life_span_month >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
		END customer_status
	FROM
	(
		SELECT
			c.customer_key,
			MIN(s.order_date) first_order,
			MAX(s.order_date) last_order,
			DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) life_span_month,
			SUM(s.sales_amount) total_sales
		FROM gold.fact_sales s
		LEFT JOIN gold.dim_customers c
		ON s.customer_key = c.customer_key
		WHERE s.order_date IS NOT NULL
		GROUP BY c.customer_key
	)SUB1
)SUB2
GROUP BY customer_status
ORDER BY total_customers DESC;
