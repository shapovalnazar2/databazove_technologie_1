
WITH ranked_items AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        quantity * unit_price AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_no
            ORDER BY quantity * unit_price DESC
        ) AS row_num
    FROM retail_sales
)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    amount,
    row_num
FROM ranked_items
WHERE row_num <= 3
ORDER BY invoice_no, row_num;



WITH ranked_items AS (
    SELECT
        invoice_no,
        stock_code,
        quantity,
        unit_price,
        quantity * unit_price AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_no
            ORDER BY quantity * unit_price DESC
        ) AS row_num
    FROM retail_sales
)
SELECT invoice_no, stock_code, amount, row_num
FROM ranked_items
WHERE invoice_no = '536366'
  AND stock_code = '22632';
