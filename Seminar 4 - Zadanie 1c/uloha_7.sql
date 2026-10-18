
WITH monthly_sales AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date)::DATE AS month,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY
        country,
        DATE_TRUNC('month', invoice_date)::DATE
),
sales_quartiles AS (
    SELECT
        country,
        month,
        total_amount,
        NTILE(4) OVER (
            PARTITION BY country
            ORDER BY total_amount DESC
        ) AS sales_quartile
    FROM monthly_sales
)
SELECT
    country,
    month,
    total_amount,
    sales_quartile
FROM sales_quartiles
ORDER BY country, month;



WITH monthly_sales AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date)::DATE AS month,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, DATE_TRUNC('month', invoice_date)::DATE
)
SELECT
    country,
    month,
    total_amount,
    NTILE(4) OVER (
        PARTITION BY country
        ORDER BY total_amount DESC
    ) AS sales_quartile
FROM monthly_sales
WHERE (country = 'Australia'
       AND month IN ('2010-12-01', '2011-01-01', '2011-02-01'))
   OR (country = 'Austria'
       AND month IN ('2010-12-01', '2011-02-01'))
ORDER BY country, month;
