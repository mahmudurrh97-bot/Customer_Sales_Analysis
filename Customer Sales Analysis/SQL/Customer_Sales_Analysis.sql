-- 1. Show the top 10 highest revenue transactions with all details
SELECT *
FROM customer_sales_analysis
ORDER BY Revenue DESC
LIMIT 10;

-- 2. Find the total revenue and profit grouped by country
SELECT Country,
       SUM(Revenue) AS total_revenue,
       SUM(Profit) AS total_profit
FROM customer_sales_analysis
GROUP BY Country
ORDER BY total_revenue DESC;

-- 3. Find the average customer age for each product category
SELECT Product_Category,
       ROUND(AVG(Customer_Age), 2) AS avg_customer_age
FROM customer_sales_analysis
GROUP BY Product_Category
ORDER BY avg_customer_age DESC;

-- 4. Get the monthly revenue trend for each year
SELECT Year,
       Month,
       SUM(Revenue) AS monthly_revenue
FROM customer_sales_analysis
GROUP BY Year, Month
ORDER BY Year, 
         CASE 
             WHEN Month = 'January' THEN 1
             WHEN Month = 'February' THEN 2
             WHEN Month = 'March' THEN 3
             WHEN Month = 'April' THEN 4
             WHEN Month = 'May' THEN 5
             WHEN Month = 'June' THEN 6
             WHEN Month = 'July' THEN 7
             WHEN Month = 'August' THEN 8
             WHEN Month = 'September' THEN 9
             WHEN Month = 'October' THEN 10
             WHEN Month = 'November' THEN 11
             WHEN Month = 'December' THEN 12
         END;

-- 5. Find the top 5 sub-categories by total order quantity
SELECT Sub_Category,
       SUM(Order_Quantity) AS total_orders
FROM customer_sales_analysis
GROUP BY Sub_Category
ORDER BY total_orders DESC
LIMIT 5;

-- 6. Compare average revenue between male and female customers
SELECT Customer_Gender,
       ROUND(AVG(Revenue), 2) AS avg_revenue
FROM customer_sales_analysis
GROUP BY Customer_Gender;

-- 7. Find the most profitable product in each product category
SELECT DISTINCT ON (Product_Category) 
       Product_Category,
       Product,
       SUM(Profit) AS total_profit
FROM customer_sales_analysis
GROUP BY Product_Category, Product
ORDER BY Product_Category, total_profit DESC;

-- 8. Calculate year-over-year revenue growth
SELECT Year,
       SUM(Revenue) AS total_revenue,
       LAG(SUM(Revenue)) OVER (ORDER BY Year) AS prev_year_revenue,
       ROUND(
           (SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY Year)) 
           * 100.0 / NULLIF(LAG(SUM(Revenue)) OVER (ORDER BY Year), 0), 2
       ) AS yoy_growth_percent
FROM customer_sales_analysis
GROUP BY Year
ORDER BY Year;

-- 9. Find the top 3 states with the highest sales per country
WITH ranked_states AS (
    SELECT Country,
           State,
           SUM(Revenue) AS state_revenue,
           RANK() OVER (PARTITION BY Country ORDER BY SUM(Revenue) DESC) AS rnk
    FROM customer_sales_analysis
    GROUP BY Country, State
)
SELECT Country, State, state_revenue
FROM ranked_states
WHERE rnk <= 3
ORDER BY Country, state_revenue DESC;

-- 10. Find customers' favorite age group by total revenue contribution
SELECT Age_Group,
       SUM(Revenue) AS total_revenue,
       ROUND(SUM(Revenue) * 100.0 / (SELECT SUM(Revenue) FROM customer_sales_analysis), 2) AS revenue_percent
FROM customer_sales_analysis
GROUP BY Age_Group
ORDER BY total_revenue DESC;
