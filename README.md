# Sales Performance & Revenue Optimization Analysis

I built this project to understand how sales performance varies across products, regions, sales channels, customers and salespeople. The analysis starts in Excel for reporting and statistical analysis, then moves to MySQL for deeper business analysis.

![Sales Performance Dashboard](assets/Dashboard.png)

---

## 1. Introduction

This project analyzes **2,000 sales orders**, with one row representing one order.

The data contains information about order dates, regions, sales channels, customer types, product categories, products, salespeople, quantity, unit price, discounts and revenue.

The main goal was to identify **revenue patterns, high-performing segments, product concentration and opportunities for improving sales performance**.

The project follows one complete workflow:

**Excel → Statistics → SQL**

Excel is used for reporting and visualization, while SQL is used for deeper analysis and business questions that go beyond the dashboard.

---

## 2. Business Problem

A business needs a simple way to understand where revenue is coming from and which areas deserve further attention.

This project focuses on questions such as:

- Which month generates the highest revenue?
- Which region contributes the most revenue?
- Which product category generates the most revenue?
- Which sales channel performs best?
- Which products are the top revenue contributors?
- Do returning customers generate higher average revenue per order?
- Which salespeople contribute the most revenue?
- How does discount level relate to order revenue?
- How concentrated is revenue among the top products?
- Which areas may provide opportunities for revenue improvement?

The objective is to turn order-level sales data into clear business insights.

> The analysis identifies patterns in the dataset. It does not prove that one factor causes another.

---

## 3. Dataset

This project uses a **practice/simulated sales dataset** created for portfolio analysis.

The final dataset contains:

- **2,000 orders**
- **One row per order**
- **12 analytical columns**
- Date range: **January–December 2026**

| Detail | Information |
|---|---|
| Project Domain | Sales / Revenue Analytics |
| Orders | **2,000** |
| Date Range | **Jan–Dec 2026** |
| Regions | **5** |
| Sales Channels | **4** |
| Customer Types | **2** |
| Product Categories | **6** |
| Products | **28** |
| Salespeople | **15** |

### Fields Used

```text
Order_ID
Date
Region
Sales_Channel
Customer_Type
Product_Category
Product
Salesperson
Quantity
Unit_Price
Discount
Revenue
