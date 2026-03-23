/* =========================================================
   Project: Retail Business Performance & Profitability Analysis
   Purpose: Data Cleaning, Profit Analysis, Inventory Insights
   ========================================================= */

/* -------------------------------
   1. View sample data
-------------------------------- */
SELECT * FROM retail_data
LIMIT 10;

/* -------------------------------
   2. Data Cleaning
   Remove records with missing values
-------------------------------- */
DELETE FROM retail_data
WHERE sales IS NULL
   OR cost IS NULL
   OR category IS NULL
   OR sub_category IS NULL;

/* -------------------------------
   3. Add Profit Column (if not exists)
-------------------------------- */
-- For MySQL
ALTER TABLE retail_data
ADD COLUMN profit DECIMAL(10,2);

UPDATE retail_data
SET profit = sales - cost;

/* -------------------------------
   4. Profit Margin by Category
-------------------------------- */
SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM retail_data
GROUP BY category
ORDER BY profit_margin_percentage ASC;

/* -------------------------------
   5. Profit Margin by Sub-Category
-------------------------------- */
SELECT 
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM retail_data
GROUP BY category, sub_category
ORDER BY profit_margin_percentage ASC;

/* -------------------------------
   6. Inventory vs Profit Analysis
-------------------------------- */
SELECT 
    category,
    AVG(inventory_days) AS avg_inventory_days,
    SUM(profit) AS total_profit
FROM retail_data
GROUP BY category
ORDER BY avg_inventory_days DESC;

/* -------------------------------
   7. Identify Loss-Making Products
-------------------------------- */
SELECT 
    product_name,
    category,
    sub_category,
    sales,
    cost,
    profit
FROM retail_data
WHERE profit < 0
ORDER BY profit ASC;

/* -------------------------------
   8. Seasonal Sales Analysis
-------------------------------- */
SELECT 
    MONTH(order_date) AS month,
    SUM(sales) AS monthly_sales
FROM retail_data
GROUP BY MONTH(order_date)
ORDER BY month;

/* -------------------------------
   9. Top Performing Products
-------------------------------- */
SELECT 
    product_name,
    category,
    SUM(profit) AS total_profit
FROM retail_data
GROUP BY product_name, category
ORDER BY total_profit DESC
LIMIT 10;
