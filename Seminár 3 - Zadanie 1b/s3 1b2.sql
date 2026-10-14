WITH category_sales AS (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT
    product_category,
    total_sales
FROM category_sales
ORDER BY total_sales DESC;