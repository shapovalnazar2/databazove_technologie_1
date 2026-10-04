-- Active: 1791112921687@@127.0.0.1@5432@datacraftinglab_db@public
-- Active: 1791112921687@@127.0.0.1@5432@datacraftinglab_db-- Active: 1791112921687@@127.0.0.1@5432@datacraftinglab_db-- Active: 1791112921687@@127.0.0.1@5432@datacraftinglab_db
SELECT *
FROM flourmills_sales;

SELECT COUNT(*)
FROM flourmills_sales;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'flourmills_sales';

SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);

SELECT COUNT(*)
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);

SELECT product_category, SUM(total_amount) AS total_sales
FROM flourmills_sales
GROUP BY product_category
ORDER BY total_sales DESC
LIMIT 1;

SELECT sales_id, sale_date, region, product_category
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

SELECT
    product_name,
    total_amount,
    (
        SELECT AVG(total_amount)
        FROM flourmills_sales
    ) AS avg_amount
FROM flourmills_sales;

SELECT product_name
FROM flourmills_sales
WHERE total_amount = 9511208.41;

SELECT
    product_name,
    total_amount,
    total_amount / (
        SELECT SUM(total_amount)
        FROM flourmills_sales
    ) AS amount_share
FROM flourmills_sales;

SELECT
    month,
    monthly_sales
FROM (
    SELECT
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
WHERE month = 8;

SELECT
    product_category,
    total_sales
FROM (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_sales
WHERE total_sales > 50000000
ORDER BY total_sales DESC;

SELECT COUNT(*)
FROM flourmills_sales AS t1
WHERE total_amount > (
    SELECT AVG(t2.total_amount)
    FROM flourmills_sales AS t2
    WHERE t2.product_category = t1.product_category
);


SELECT
    s.product_name,
    s.region,
    s.total_amount,
    (
        SELECT MIN(r.total_amount)
        FROM flourmills_sales r
        WHERE r.region = s.region
    ) AS region_min_amount
FROM flourmills_sales s;

Ak sa produkt nachádza vo výsledku, znamená to, že bol predaný aspoň v dvoch rôznych mesiacoch