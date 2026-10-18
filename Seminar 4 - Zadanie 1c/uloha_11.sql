
WITH ranked_items AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        DENSE_RANK() OVER (
            PARTITION BY invoice_no
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM retail_sales
)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    price_rank
FROM ranked_items
WHERE price_rank <= 5
ORDER BY invoice_no, price_rank, stock_code;



WITH ranked_items AS (
    SELECT
        invoice_no,
        DENSE_RANK() OVER (
            PARTITION BY invoice_no
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM retail_sales
)
SELECT COUNT(*) AS total_rows
FROM ranked_items
WHERE price_rank <= 5;
