WITH summary AS (
    SELECT
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(sales) AS total_revenue,
        SUM(quantity) AS total_quantity,
        SUM(profit) AS total_profit
    FROM sales_orders
)
SELECT
    total_orders,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    total_quantity,
    ROUND(total_profit::numeric, 2) AS total_profit,
    ROUND(
        ((total_profit / NULLIF(total_revenue, 0)) * 100)::numeric,
        2
    ) AS profit_margin_percent
FROM summary;
