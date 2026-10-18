
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
WHERE customer_id IS NOT NULL;
