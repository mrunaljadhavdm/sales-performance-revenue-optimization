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

## 4. Key Results

The findings below describe this practice dataset; they are not real-company outcomes.

| KPI / finding | Result |
|---|---:|
| Total revenue | **$2,452,084.30** |
| Orders analyzed | **2,000** |
| Quantity sold | **5,552** |
| Average revenue per order | **$1,226.04** |
| Highest-revenue month | **November — approximately $274.37K** |
| Highest-revenue region | **North — approximately $561.75K** |
| Highest-revenue channel | **Online — approximately $791.54K** |
| Highest-revenue category | **Computers — approximately $1.35M** |
| Revenue share of the top five products | **Approximately 57.7%** |
| High-revenue outliers by the IQR rule | **124 orders (6.20%)** |

### Three Key Findings

1. **Revenue is concentrated among a small group of products.** The top five products contribute approximately **57.7%** of total revenue. This concentration makes the leading products important to monitor and gives management a reason to review availability and performance for those products.
2. **Revenue differs across channels and regions.** Online is the leading channel at approximately **$791.54K**, while North is the leading region at approximately **$561.75K**. A useful follow-up is to compare product mix, order size, and customer type within these segments.
3. **A small portion of orders have unusually high revenue.** The IQR method flags **124 orders (6.20%)** as high-revenue outliers. These orders may reflect legitimate high-value purchases or data patterns that deserve review; an outlier is not automatically an error.

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

- Monitor the leading products because they represent a substantial share of revenue.
- Compare Online with other channels using product mix, average order revenue, and customer type before deciding where to invest further.
- Investigate the North region's performance by category and product to understand which combinations contribute most.
- Review high-revenue outliers individually before treating them as errors or unusual customer behavior.
- Treat discount comparisons as descriptive: the dataset does not prove that a discount caused an increase or decrease in revenue.

## 7. Validation and Limitations

- The project includes row-count, duplicate-order, missing-value, category, and revenue-formula checks.
- Revenue is derived from quantity, unit price, and discount; correlations involving revenue need careful interpretation.
- The dataset is simulated/practice data and is not a messy production ETL dataset.
- No cost field is included, so profit or margin cannot be calculated.
- This is descriptive and diagnostic analysis, not forecasting or predictive modeling.
- Correlation and group differences do not establish causation.

.




