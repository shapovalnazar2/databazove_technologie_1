CREATE VIEW regional_monthly_sales AS
SELECT
    c.region,
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(o.sales) AS monthly_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.region,
    DATE_TRUNC('month', o.order_date);

SELECT *
FROM regional_monthly_sales
WHERE region = 'West'
ORDER BY month;