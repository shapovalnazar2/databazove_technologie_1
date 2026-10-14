CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_sales NUMERIC(12, 2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Obdobie: % až %, Celkový predaj: %',
        start_date, end_date, total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');
