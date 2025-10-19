# Supermarket-Sales-Analysis (SQL)

This project explores Supermarket-Sales data using **SQL Server** to uncover business insights and performance trends.  
It combines feature engineering, exploratory data analysis (EDA), and analytical SQL queries to understand customer behavior and sales performance.

## 🔍 Key Objectives
- Perform **feature engineering** by creating new fields such as:
  - `Time_of_day` → Categorized transactions by Morning, Afternoon, and Evening  
  - `Day_name` → Extracted weekday names from the sales date  
  - `Month_name` → Identified monthly trends
- Conduct **EDA** to answer key business questions:
  - Which cities and branches perform best?  
  - What are the top-selling product lines and payment methods?  
  - When do customers make the most purchases?  
  - Which customer type generates the most revenue?
- Apply **window functions** and **aggregations** to:
  - Calculate monthly and daily **running totals**
  - Rank product lines by total revenue
  - Compare performance against the **global sales average**

## 📊 Insights
- **January** recorded the highest total revenue among all months.  
- **Food & Beverages** and **Sports & Travel** are the most profitable product lines.  
- **Evening** is the busiest time of day for sales.  
- **Member** customers contribute slightly more revenue than **Normal** ones.  
- **Naypyitaw** city leads in total sales and VAT contribution.

## ⚙️ Tools & Skills Used
- **SQL Server**
- **Window functions (RANK, NTILE, SUM OVER, etc.)**
- **Data cleaning and transformation**
- **Business intelligence querying**
