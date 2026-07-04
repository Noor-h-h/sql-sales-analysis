# sql-sales-analysis
# SQL Sales Analysis — Online Retail Dataset

## Project Overview
Analysis of 500K+ e-commerce transactions using MySQL to uncover sales trends, top products, and customer behavior.

## Dataset
- Source: UCI Machine Learning Repository — Online Retail Dataset
- Records: 541,909 transactions (397,884 after cleaning)
- Period: December 2010 — December 2011

## Tools
- MySQL / MySQL Workbench
- Python (pandas, sqlalchemy) — for data import

## Key Findings
- Total Revenue: **$8,911,407**
- Total Orders: **18,532**
- Total Customers: **4,338**
- Top Month: **November 2011 — $1,161,817**
- Top Product: **PAPER CRAFT, LITTLE BIRDIE — $168,469**
- Top Country: **United Kingdom — 82% of total revenue**

## Analysis Covered
1. Data Cleaning — removed nulls and returns
2. Total Revenue, Orders, and Customers
3. Top 10 Products by Quantity
4. Top 10 Countries by Revenue
5. Monthly Revenue Trends
6. Customers Above Average Spending (Subquery)
7. Top Product per Country (Window Functions + CTE)
8. First Order per Customer (ROW_NUMBER)
9. Monthly Revenue vs Previous Month (LAG)
10. Running Total (SUM OVER)
11. Customer Segmentation — High / Medium / Low (CASE WHEN)
