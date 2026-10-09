/* ============================================================
   SALES PERFORMANCE & REVENUE OPTIMIZATION ANALYSIS
   MySQL 8+ | Database: sales_performance
   Table: sales_data_performance

   Excel = reporting, dashboard, statistics
   SQL   = querying, ranking, comparing, deeper business questions
   (These queries are NOT a copy of the Excel dashboard.)

  Source workbook: Sales_Performance_Revenue_Optimization.xlsx
SQL import file: Sales_Performance_CSV.csv
   ============================================================ */


/* ============================================================
   SECTION 1. DATABASE SETUP
   ============================================================ */

CREATE DATABASE IF NOT EXISTS sales_performance;

USE sales_performance;


/* ============================================================
   SECTION 2. TABLE CREATION AND DATA IMPORT
   ============================================================ */

-- Column names follow the Excel headers, with spaces replaced by
-- underscores ("Order ID" -> Order_ID, "Unit Price" -> Unit_Price).
--
-- Revenue is DECIMAL(12,4) on purpose. In the Excel sheet, 336 orders
-- have revenue with more than 2 decimals (e.g. 6.208). Storing 2 decimals
-- would round them and the total would drift by a few cents from Excel.
--
-- Date is a normal column name in MySQL (DATE is not a reserved word).

CREATE TABLE IF NOT EXISTS sales_data_performance (
    Order_ID         VARCHAR(20)   NOT NULL PRIMARY KEY,
    Date             DATE          NOT NULL,
    Region           VARCHAR(30)   NOT NULL,
    Sales_Channel    VARCHAR(30)   NOT NULL,
    Customer_Type    VARCHAR(20)   NOT NULL,
    Product_Category VARCHAR(30)   NOT NULL,
    Product          VARCHAR(60)   NOT NULL,
    Salesperson      VARCHAR(50)   NOT NULL,
    Quantity         INT           NOT NULL,
    Unit_Price       DECIMAL(10,2) NOT NULL,
    Discount         DECIMAL(4,2)  NOT NULL,   -- stored as 0.05, not 5%
    Revenue          DECIMAL(12,4) NOT NULL
);


/* ============================================================
   SECTION 3. DATA-QUALITY CHECKS
   ============================================================ */

-- 3.1 Business question: Did every row load?
-- What it does: counts the rows in the table.

SELECT COUNT(*) AS Total_Rows
FROM sales_data_performance;


-- 3.2 Business question: Is each order recorded only once?
-- What it does: lists any Order_ID that appears more than once.
-- An empty result means no duplicates.

SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM sales_data_performance
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- 3.3 Business question: Is anything missing?
-- What it does: counts NULL (or blank text) in every column.
-- Every value should be 0.

SELECT
    SUM(Order_ID IS NULL OR Order_ID = '')                   AS Missing_Order_ID,
    SUM(Date IS NULL)                                        AS Missing_Date,
    SUM(Region IS NULL OR Region = '')                       AS Missing_Region,
    SUM(Sales_Channel IS NULL OR Sales_Channel = '')         AS Missing_Sales_Channel,
    SUM(Customer_Type IS NULL OR Customer_Type = '')         AS Missing_Customer_Type,
    SUM(Product_Category IS NULL OR Product_Category = '')   AS Missing_Product_Category,
    SUM(Product IS NULL OR Product = '')                     AS Missing_Product,
    SUM(Salesperson IS NULL OR Salesperson = '')             AS Missing_Salesperson,
    SUM(Quantity IS NULL)                                    AS Missing_Quantity,
    SUM(Unit_Price IS NULL)                                  AS Missing_Unit_Price,
    SUM(Discount IS NULL)                                    AS Missing_Discount,
    SUM(Revenue IS NULL)                                     AS Missing_Revenue
FROM sales_data_performance;


-- 3.4 Business question: What period does the data cover?
-- What it does: finds the first and last order date.

SELECT
    MIN(Date) AS First_Order_Date,
    MAX(Date) AS Last_Order_Date
FROM sales_data_performance;


-- 3.5 Business question: Which regions exist, and is spelling consistent?
-- What it does: lists each region with its order count.

SELECT Region, COUNT(*) AS Orders
FROM sales_data_performance
GROUP BY Region
ORDER BY Region;


-- 3.6 Business question: Which sales channels exist?

SELECT Sales_Channel, COUNT(*) AS Orders
FROM sales_data_performance
GROUP BY Sales_Channel
ORDER BY Sales_Channel;


-- 3.7 Business question: Which customer types exist?

SELECT Customer_Type, COUNT(*) AS Orders
FROM sales_data_performance
GROUP BY Customer_Type
ORDER BY Customer_Type;


-- 3.8 Business question: Which product categories exist?

SELECT Product_Category, COUNT(*) AS Orders
FROM sales_data_performance
GROUP BY Product_Category
ORDER BY Product_Category;


-- 3.9 Business question: Which discount levels are used, and how often?
-- What it does: lists every discount value with its order count, so I
-- can confirm they are decimals (0.05) and not percentages (5).

SELECT Discount, COUNT(*) AS Orders
FROM sales_data_performance
GROUP BY Discount
ORDER BY Discount;


-- 3.10 Business question: Do the revenue numbers make sense?
-- What it does: checks (a) zero or negative values, (b) whether
-- Revenue = Quantity x Unit_Price x (1 - Discount) for every order.
-- Both mismatch counts should be 0.

SELECT
    SUM(Revenue <= 0)  AS Non_Positive_Revenue,
    SUM(Quantity <= 0) AS Non_Positive_Quantity,
    SUM(ABS(Revenue - Quantity * Unit_Price * (1 - Discount)) > 0.01) AS Revenue_Formula_Mismatch
FROM sales_data_performance;


/* ============================================================
   SECTION 4. PROJECT KPI VALIDATION
   ============================================================ */

-- 4.1 Business question: Do the SQL totals match the Excel dashboard?
-- What it does: calculates the four headline KPIs from the imported data.
-- Compare them by eye with the Excel dashboard and Statistical_Analysis
-- sheet (values are listed in SQL_Analysis_Context.md). No Excel numbers
-- are typed into this file on purpose. If they differ, flag it; do not
-- quietly edit either side.

SELECT
    ROUND(SUM(Revenue), 2)  AS Total_Revenue,
    COUNT(*)                AS Total_Orders,
    SUM(Quantity)           AS Total_Quantity,
    ROUND(AVG(Revenue), 2)  AS Average_Revenue_Per_Order
FROM sales_data_performance;


/* ============================================================
   SECTION 5. BUSINESS ANALYSIS QUERIES
   ============================================================ */

-- Q1a. Business question: Which orders earned more than the average order?
-- What it does: the subquery works out the overall average order revenue,
-- and the main query keeps only orders above it. LIMIT 20 shows the top
-- ones; remove it to see the full list.

SELECT
    Order_ID,
    Date,
    Product,
    Salesperson,
    Revenue
FROM sales_data_performance
WHERE Revenue > (SELECT AVG(Revenue) FROM sales_data_performance)
ORDER BY Revenue DESC, Order_ID
LIMIT 20;


-- Q1b. Business question: How much of the business do those above-average
-- orders represent?
-- What it does: counts them and works out their share of orders and revenue.
-- Shows whether a minority of orders carry most of the revenue.

SELECT
    SUM(Revenue > avg_value.Avg_Order_Revenue)                          AS Above_Average_Orders,
    ROUND(SUM(Revenue > avg_value.Avg_Order_Revenue) * 100 / COUNT(*), 2) AS Pct_Of_Orders,
    ROUND(SUM(CASE WHEN Revenue > avg_value.Avg_Order_Revenue THEN Revenue END)
          * 100 / SUM(Revenue), 2)                                       AS Pct_Of_Revenue
FROM sales_data_performance
CROSS JOIN (SELECT AVG(Revenue) AS Avg_Order_Revenue FROM sales_data_performance) AS avg_value;


-- Q5. Business question: Which discount band has the highest average
-- order revenue?
-- What it does: groups the discount values into four bands, then compares
-- order count, average and total revenue per band. Bands are my own
-- choice, based on the discount values found in check 3.9.

SELECT
    CASE
        WHEN Discount = 0               THEN '1. No discount'
        WHEN Discount <= 0.05           THEN '2. Low (up to 5%)'
        WHEN Discount <= 0.10           THEN '3. Medium (6% to 10%)'
        ELSE                                 '4. High (above 10%)'
    END AS Discount_Band,
    COUNT(*)                AS Orders,
    ROUND(AVG(Revenue), 2)  AS Avg_Order_Revenue,
    ROUND(SUM(Revenue), 2)  AS Total_Revenue
FROM sales_data_performance
GROUP BY Discount_Band
ORDER BY Avg_Order_Revenue DESC;


-- Q6. Business question: Do Returning customers have a higher
-- average order revenue than New customers, and does this vary
-- by sales channel?


SELECT
    Sales_Channel,
    Customer_Type,
    COUNT(*) AS Orders,
    ROUND(AVG(Revenue), 2) AS Average_Order_Revenue,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM sales_data_performance
GROUP BY Sales_Channel, Customer_Type
ORDER BY Sales_Channel, Average_Order_Revenue DESC;


-- Q7. Business question: Which salespeople earn more than the typical
-- salesperson?
-- What it does: totals revenue per salesperson and keeps only those above
-- the average salesperson total. I used the data's own average as the
-- threshold instead of picking a made-up number.

SELECT
    Salesperson,
    COUNT(*)                AS Orders,
    ROUND(SUM(Revenue), 2)  AS Total_Revenue
FROM sales_data_performance
GROUP BY Salesperson
HAVING SUM(Revenue) > (
    SELECT AVG(Salesperson_Total)
    FROM (
        SELECT SUM(Revenue) AS Salesperson_Total
        FROM sales_data_performance
        GROUP BY Salesperson
    ) AS salesperson_totals
)
ORDER BY Total_Revenue DESC;


/* ============================================================
   SECTION 6. ADVANCED BUT FRESHER-FRIENDLY SQL ANALYSIS
   ============================================================ */

-- Q2. Business question: Which products lead each category?
-- What it does: totals revenue per product, then ranks products inside
-- their own category and keeps the top 3 of each. RANK() gives tied
-- products the same rank, so a category can show more than 3 rows on a tie.

WITH product_revenue AS (
    SELECT
        Product_Category,
        Product,
        SUM(Revenue) AS Total_Revenue
    FROM sales_data_performance
    GROUP BY Product_Category, Product
),
ranked_products AS (
    SELECT
        Product_Category,
        Product,
        Total_Revenue,
        RANK() OVER (
            PARTITION BY Product_Category
            ORDER BY Total_Revenue DESC
        ) AS Rank_In_Category
    FROM product_revenue
)
SELECT
    Product_Category,
    Rank_In_Category,
    Product,
    ROUND(Total_Revenue, 2) AS Total_Revenue
FROM ranked_products
WHERE Rank_In_Category <= 3
ORDER BY Product_Category, Rank_In_Category;


-- Q3. Business question: How does revenue move from month to month?
-- What it does: totals revenue per month, then uses LAG() to bring in the
-- previous month so I can show the change and growth %. January has no
-- previous month, so its change shows NULL. NULLIF avoids dividing by zero.

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(Date, '%Y-%m') AS Order_Month,
        SUM(Revenue)               AS Month_Revenue
    FROM sales_data_performance
    GROUP BY DATE_FORMAT(Date, '%Y-%m')
)
SELECT
    Order_Month,
    ROUND(Month_Revenue, 2)                                                AS Current_Month_Revenue,
    ROUND(LAG(Month_Revenue) OVER (ORDER BY Order_Month), 2)               AS Previous_Month_Revenue,
    ROUND(Month_Revenue - LAG(Month_Revenue) OVER (ORDER BY Order_Month), 2) AS Revenue_Change,
    ROUND(
        (Month_Revenue - LAG(Month_Revenue) OVER (ORDER BY Order_Month))
        * 100 / NULLIF(LAG(Month_Revenue) OVER (ORDER BY Order_Month), 0),
    2)                                                                     AS Growth_Pct
FROM monthly_revenue
ORDER BY Order_Month;


-- Q4. Business question: What share of total revenue does each
-- salesperson bring in?
-- What it does: totals revenue per salesperson, then divides by the
-- company total using a window SUM() so no second query is needed.
-- Rank 1 is the highest earner.

WITH salesperson_revenue AS (
    SELECT
        Salesperson,
        SUM(Revenue) AS Total_Revenue
    FROM sales_data_performance
    GROUP BY Salesperson
)
SELECT
    Salesperson,
    ROUND(Total_Revenue, 2)                              AS Total_Revenue,
    ROUND(Total_Revenue * 100 / SUM(Total_Revenue) OVER (), 2) AS Revenue_Share_Pct,
    RANK() OVER (ORDER BY Total_Revenue DESC)            AS Revenue_Rank
FROM salesperson_revenue
ORDER BY Revenue_Rank;


-- Q8a. Business question: Which individual orders are in the top 10%
-- by revenue?
-- What it does: NTILE(10) splits all orders into 10 equal-sized groups
-- after sorting by revenue (group 1 = highest). I keep group 1 and show
-- the 20 biggest. Orders with equal revenue at a group edge may land in
-- either group.

WITH order_groups AS (
    SELECT
        Order_ID,
        Date,
        Product,
        Salesperson,
        Revenue,
        NTILE(10) OVER (ORDER BY Revenue DESC, Order_ID) AS Revenue_Group
    FROM sales_data_performance
)
SELECT
    Order_ID,
    Date,
    Product,
    Salesperson,
    Revenue,
    Revenue_Group
FROM order_groups
WHERE Revenue_Group = 1
ORDER BY Revenue DESC, Order_ID
LIMIT 20;


-- Q8b. Business question: How much revenue does the top 10% of orders
-- bring in compared with the rest?
-- What it does: summarises all ten groups (orders, revenue, share of
-- total). Tells me how dependent the business is on its biggest orders.

WITH order_groups AS (
    SELECT
        Revenue,
        NTILE(10) OVER (ORDER BY Revenue DESC, Order_ID) AS Revenue_Group
    FROM sales_data_performance
),
group_summary AS (
    SELECT
        Revenue_Group,
        COUNT(*)     AS Orders,
        SUM(Revenue) AS Group_Revenue
    FROM order_groups
    GROUP BY Revenue_Group
)
SELECT
    Revenue_Group,
    Orders,
    ROUND(Group_Revenue, 2)                                    AS Group_Revenue,
    ROUND(Group_Revenue * 100 / SUM(Group_Revenue) OVER (), 2) AS Revenue_Share_Pct
FROM group_summary
ORDER BY Revenue_Group;


/* ============================================================
   SECTION 7. FINAL VALIDATION
   ============================================================ */

-- 7.1 Business question: Is the table clean and complete?
-- What it does: compares total rows with distinct Order_IDs.
-- Both numbers should be equal.

SELECT
    COUNT(*)                 AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Distinct_Order_IDs
FROM sales_data_performance;


-- 7.2 Business question: Do the grouped totals add back to the grand total?
-- What it does: totals revenue by region and by category and compares each
-- with the grand total. Differences should be 0.

SELECT
    ROUND(grand.Total_Revenue, 2)                          AS Grand_Total_Revenue,
    ROUND(by_region.Region_Sum - grand.Total_Revenue, 4)   AS Region_Difference,
    ROUND(by_category.Category_Sum - grand.Total_Revenue, 4) AS Category_Difference
FROM
    (SELECT SUM(Revenue) AS Total_Revenue FROM sales_data_performance) AS grand,
    (SELECT SUM(Region_Total) AS Region_Sum
       FROM (SELECT SUM(Revenue) AS Region_Total
               FROM sales_data_performance GROUP BY Region) AS r) AS by_region,
    (SELECT SUM(Category_Total) AS Category_Sum
       FROM (SELECT SUM(Revenue) AS Category_Total
               FROM sales_data_performance GROUP BY Product_Category) AS c) AS by_category;


-- 7.3 Final KPI summary (same as 4.1, repeated at the end on purpose so the
-- final numbers can be compared once more with Excel).
SELECT
    ROUND(SUM(Revenue), 2)  AS Total_Revenue,
    COUNT(*)                AS Total_Orders,
    SUM(Quantity)           AS Total_Quantity,
    ROUND(AVG(Revenue), 2)  AS Average_Revenue_Per_Order
FROM sales_data_performance;






