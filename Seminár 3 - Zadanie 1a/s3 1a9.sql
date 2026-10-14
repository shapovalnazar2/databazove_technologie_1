CREATE OR REPLACE PROCEDURE get_customer_sales(
    p_customer_id VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(12, 2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Zákazník: %, Celkový predaj: %',
        p_customer_id, v_total_sales;
END;
$$;

CALL get_customer_sales('C001');