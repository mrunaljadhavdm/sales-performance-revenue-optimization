# Sales Performance & Revenue Optimization Analysis

**Tools:** Microsoft Excel · MySQL 8+ · Statistics  
**Domain:** Sales and Revenue Analytics  
**Project type:** Descriptive and diagnostic data analytics  
**Dataset:** Simulated portfolio dataset

> This project uses practice data created for portfolio analysis. The findings demonstrate an analytics workflow and should not be interpreted as results from a real company.

![Sales Performance Dashboard](assets/Dashboard.png)

## 1. Business Problem

A business wants to understand where its revenue comes from and which products, regions, channels, customer types, and salespeople deserve further attention. A dashboard alone is not enough: decision-makers also need reliable calculations, evidence-backed findings, and clear next steps.

This project answers questions such as:

- Which months and regions contribute the most revenue?
- Which product categories and products are the strongest revenue contributors?
- Which sales channel generates the most revenue?
- How does average order revenue differ between new and returning customers?
- How is revenue distributed across orders and products?
- What patterns appear across discount levels, and what should be investigated further?

## 2. Dataset

The dataset contains **2,000 orders**, with one row representing one order, covering **January–December 2026**.

| Dataset characteristic | Detail |
|---|---:|
| Orders | 2,000 |
| Analytical columns | 12 |
| Regions | 5 |
| Sales channels | 4 |
| Customer types | 2 |
| Product categories | 6 |
| Products | 28 |
| Salespeople | 15 |

Fields include `Order_ID`, `Date`, `Region`, `Sales_Channel`, `Customer_Type`, `Product_Category`, `Product`, `Salesperson`, `Quantity`, `Unit_Price`, `Discount`, and `Revenue`.

Revenue is calculated as:

```text
Revenue = Quantity × Unit Price × (1 − Discount)
```

The project validates this derived measure before interpreting the sales results.

## 3. Tools and Methodology

### Excel

- Organized the order-level data in an Excel Table.
- Built PivotTables and supporting calculations for business questions.
- Created an interactive dashboard with KPI cards, charts, and slicers.
- Used descriptive statistics and IQR-based outlier analysis.

### MySQL

- Checked row counts, unique order IDs, missing values, valid categories, and revenue calculations.
- Answered business questions using aggregations, subqueries, CTEs, `CASE WHEN`, ranking, and window functions.
- Used `RANK()` to compare products, `LAG()` for month-over-month analysis, and `NTILE()` to examine order-value segments.
- Reconciled the SQL KPI summary with the project reporting figures.

### Statistics

- Mean, median, standard deviation, quartiles, and interquartile range (IQR).
- Correlation and revenue-distribution analysis.
- Outlier identification to find high-revenue orders that deserve closer review.

## 4. Key Results and Findings

The figures below describe this simulated portfolio dataset, not a real company's results.

| KPI / finding | Result |
|---|---:|
| Total revenue | **$2,452,084.30** |
| Orders analyzed | **2,000** |
| Quantity sold | **5,552** |
| Average revenue per order | **$1,226.04** |
| Highest-revenue month | **November — approximately $274.37K** |
| Computers share of total revenue | **54.9% (approximately $1.35M)** |
| Top five products' share of total revenue | **Approximately 57.7%** |
| Online vs Corporate Sales revenue | **$791.54K vs $718.75K; Online is about 10% higher** |
| North vs Central regional revenue | **$561.75K vs $556.71K; a near tie (under 1% apart)** |
| Returning vs new average revenue per order | **Approximately $1,284 vs $1,116** |
| Highest-revenue salesperson | **Mei Tan — approximately $224.07K (9.14% of total revenue)** |
| Salespeople above average salesperson revenue | **8 of 15** |
| Average order revenue by discount group | **Low-discount band: approximately $1,433.67; no-discount group: approximately $1,005.71** |
| Above-average orders' share of total revenue | **32.2% of orders contribute approximately 84.08% of revenue** |
| Top 10% of orders' share of total revenue | **Approximately 45.14%** |
| High-revenue outliers by the IQR rule | **124 orders (6.20%)** |

### What the results show

1. **Revenue is concentrated by category and product.** Computers account for approximately **54.9%** of revenue, while the top five products contribute approximately **57.7%**. These are key revenue drivers to keep visible in regular performance reviews.
2. **Online leads Corporate Sales, while North and Central are almost tied.** Online revenue is approximately **$791.54K**, compared with **$718.75K** from Corporate Sales—a lead of about **10%**. North generates approximately **$561.75K** and Central **$556.71K**, less than **1%** apart, so the regions should be described as a near tie rather than a decisive regional lead.
3. **A relatively small group of orders contributes most revenue.** Orders above average revenue make up approximately **32.2%** of orders but contribute **84.08%** of total revenue. The top 10% of orders alone contribute approximately **45.14%** of total revenue, showing how much revenue is concentrated in the highest-value segment. Because average revenue is pulled upward by high-value orders, the median (approximately **$406.55**) is also useful context for a typical order.
4. **Returning customers and some salespeople have higher observed revenue contribution.** Returning customers average approximately **$1,284 per order**, versus **$1,116** for new customers. Mei Tan leads individual salesperson revenue at approximately **$224.07K (9.14%)**, and **8 of 15** salespeople are above the average salesperson revenue. These are descriptive comparisons, not evidence of why the differences occur.
5. **The low-discount band has the highest average order revenue, but this is not a causal result.** Its average is approximately **$1,433.67**, compared with **$1,005.71** for orders with no discount. Product mix, order composition, or other factors may explain some or all of this difference; this comparison alone does not establish that lower discounts increase revenue.
6. **Outliers should be reviewed rather than automatically removed.** The IQR rule flags **124 orders (6.20%)** as high-revenue outliers. They may represent legitimate high-value purchases or records that require checking.

## 5. Dashboard

The `Sales_Dashboard` worksheet presents:

- Total Revenue, Total Orders, Quantity Sold, and Average Order Value.
- Revenue by month, region, sales channel, and product category.
- Top five products by revenue.
- Slicers for product category, sales channel, region, and customer type.

The other workbook sheets support reproducibility:

- `Sales_Data` — order-level records.
- `Supporting_pivots` — supporting PivotTables.
- `Business_Questions` — questions, answers, and analysis sources.
- `Statistical_Analysis` — descriptive statistics, correlations, and IQR analysis.

## 6. Business Recommendations

These are proposed actions for a hypothetical business, based on patterns in the simulated dataset.

- **Merchandising lead — review product concentration weekly.** Track revenue share and availability for the top five products (approximately **57.7%** of revenue) and Computers (**54.9%** of revenue). Record whether each leading product's revenue share or availability changes from the prior review before making assortment decisions.
- **Sales channel lead — compare Online and Corporate Sales monthly.** Online generated **$791.54K** versus **$718.75K** for Corporate Sales. Break the comparison down by product category and customer type before reallocating campaign effort or budget; measure each channel's revenue and average order revenue month over month.
- **Regional sales manager — investigate the North/Central near tie.** North generated **$561.75K** and Central **$556.71K**, a gap of less than **1%**. Review category and channel contributions for both regions, then document the largest contributing combinations in the next monthly sales review.
- **CRM/customer relationship lead — test a returning-customer initiative.** Returning customers averaged approximately **$1,284 per order**, compared with **$1,116** for new customers. Run a defined pilot and compare average revenue per order and repeat-purchase rate against the pre-pilot baseline; do not assume the difference is caused by customer tenure alone.
- **Sales operations analyst — report high-value order concentration.** Track the share of revenue from above-average orders (**32.2% of orders; 84.08% of revenue**) and the top 10% of orders (**45.14% of revenue**) in each reporting cycle. Use both average and median order revenue when discussing typical order value.
- **Promotions owner — review discount bands before changing discount policy.** The low-discount band averaged **$1,433.67** per order versus **$1,005.71** in the no-discount group. Compare product and customer mix within the bands and report the segment results before proposing a discount change; the current comparison does not prove causation.
- **Data/ sales operations owner — disposition all 124 IQR outliers.** Review the **124** high-revenue orders, classify each as valid or requiring correction, and document the count in each group. Do not delete an order solely because it falls outside the statistical fence.

## 7. Validation and Limitations

- The project includes row-count, duplicate-order, missing-value, category, and revenue-formula checks.
- Revenue is derived from quantity, unit price, and discount; correlations involving revenue need careful interpretation.
- The dataset is simulated/practice data and is not a messy production ETL dataset.
- No cost field is included, so profit or margin cannot be calculated.
- This is descriptive and diagnostic analysis, not forecasting or predictive modeling.
- Correlation and group differences do not establish causation.

## 8. Reproducibility

To reproduce the analysis from the repository:

1. Open the Excel workbook in the `excel/` folder and inspect the `Sales_Data`, `Supporting_pivots`, `Sales_Dashboard`, `Business_Questions`, and `Statistical_Analysis` sheets.
2. Import the SQL-ready order-level CSV from `data/` into MySQL 8+ using the table/column definitions in the SQL script in `sql/`.
3. Run the SQL validation queries first, then run the analysis queries for channel, region, salesperson, discount, customer type, and order-value segments.
4. Compare row counts, revenue calculations, and KPI outputs with the Excel workbook. Treat a difference between a SQL result and the documented source KPI as a reconciliation item to investigate rather than silently replacing the source KPI.
5. To view the dashboard image in the README, keep the dashboard screenshot in the `assets/` folder and ensure the Markdown image path matches its filename.
