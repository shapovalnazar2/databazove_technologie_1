
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.category,
        p.product_id,
        p.product_name
),
category_sales AS (
    SELECT
        category,
        product_name,
        product_sales,
        SUM(product_sales) OVER (
            PARTITION BY category
        ) AS category_total
    FROM product_sales
)
SELECT
    category,
    product_name,
    product_sales,
    category_total,
    ROUND(
        product_sales * 100.0 / NULLIF(category_total, 0),
        2
    ) AS pct_of_category
FROM category_sales
ORDER BY category, product_name;
