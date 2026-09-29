SELECT category, sub_category, sales, profit, ROUND((profit / NULLIF(sales, 0)) * 100, 2) AS profit_margin_pct FROM sales_orders;
