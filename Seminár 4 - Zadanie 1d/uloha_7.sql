WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)::DATE
),
previous_month AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly
)
SELECT
    month,
    monthly_sales,
    prev_month_sales,
    monthly_sales - prev_month_sales AS sales_change,
    ROUND(
        ((monthly_sales - prev_month_sales) / prev_month_sales) * 100,
        2
    ) AS growth_percentage
FROM previous_month
ORDER BY month ASC;

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)::DATE
),
previous_month AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly
)
SELECT ROUND(
    (
        (monthly_sales - prev_month_sales)
        / NULLIF(prev_month_sales, 0) * 100
    )::NUMERIC,
    2
) AS growth_percentage
FROM previous_month
WHERE month = DATE '2024-04-01';