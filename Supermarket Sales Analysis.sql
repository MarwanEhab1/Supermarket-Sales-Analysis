
-- Author: Marwan Ehab
-- SQL Server compatible
use walmart;

------------------- Feature Engineering -----------------------------
-- 1. Time_of_day


select [Time],
(case
      when [Time] between '00:00:00' AND '12:00:00' then 'Morning'
	  when [Time] between '12:01:00' AND '16:00:00' then 'Afternoon'
	  else 'Evening'
end) as 'Time_of_day'
from sales ;




alter table sales
add  Time_of_day VARCHAR(20)


update sales
set Time_of_day =(case
      when [Time] between '00:00:00' AND '12:00:00' then 'Morning'
	  when [Time] between '12:01:00' AND '16:00:00' then 'Afternoon'
	  else 'Evening'
end) ;




-- 2.Day_name

SELECT 
    DATENAME(WEEKDAY, CAST([Date] AS date)) AS day_name
FROM sales;


alter table sales
add  day_name varchar(10)

UPDATE sales
SET day_name = DATENAME(WEEKDAY, [Date]);



-- 3.Momth_name

select 
 datename(month,[Date])as Month_name
from sales

alter table sales
add Month_name varchar(10)


update sales
set  Month_name = datename(month,[Date])




-- ----------------Exploratory Data Analysis (EDA)------------------------

-- How many distinct cities are present in the dataset?
select distinct(City)
from sales;
-- Output sample:
-- Naypyitaw
-- Yangon
-- Mandalay


-- In which city is each branch situated?
select distinct (City), (Branch)
from sales;
-- Output sample:
-- Mandalay    B
-- Naypyitaw   C
-- Yangon      A


-- How many distinct product lines are there in the dataset?
select Distinct Product_line
from sales;
-- Output sample:
-- Fashion accessories
-- Health and beauty
-- Electronic accessories
-- Food and beverages
-- Sports and travel
-- Home and lifestyle


-- What is the most common payment method?
select Payment,
       count(Payment) as common_payment_method
from sales
group by Payment
order by common_payment_method desc;
-- Output sample:
-- Ewallet    345
-- Cash       344
-- Credit card 311


-- What is the most selling product line?
select top 1
Product_line,
count(Product_line) AS most_selling_product
from sales
group by Product_line 
order by most_selling_product desc;
-- Output sample:
-- Fashion accessories 178


-- What is the total revenue by month?
select 
Month_name,
round(sum(Total),2) as total_revenue
from sales
group by Month_name
order by total_revenue desc;
-- Output sample:
-- January 116291.87
-- March   109455.51
-- February 97219.37


-- Which month recorded the highest Cost of Goods Sold (COGS)?
select 
Month_name,
round(sum(cogs),2) as total_cogs
from sales
group by Month_name
order by total_cogs desc;
-- Output sample:
-- January 110754.16
-- March   104243.34
-- February 92589.88


-- Which product line generated the highest revenue?
select 
Product_line,
round(sum(Total),2) as total_revenue
from sales
group by Product_line
order by total_revenue desc;
-- Output sample:
-- Food and beverages    56144.84
-- Sports and travel     55122.83
-- Electronic accessories 54337.53
-- Fashion accessories    54305.9
-- Home and lifestyle     53861.91
-- Health and beauty      49193.74


-- Which city has the highest revenue?
select 
City,
round(sum(Total),2) as total_revenue
from sales
group by City
order by total_revenue desc;
-- Output sample:
-- Naypyitaw 110568.71
-- Yangon    106200.37
-- Mandalay  106197.67


-- Which product line incurred the highest VAT?
SELECT 
    Product_line,
    Round(SUM([Tax_5]),2) AS Total_VAT
FROM sales
GROUP BY Product_line
ORDER BY Total_VAT DESC;
-- Output sample:
-- Food and beverages      2673.56
-- Sports and travel       2624.9
-- Electronic accessories  2587.5
-- Fashion accessories     2586
-- Home and lifestyle      2564.85
-- Health and beauty       2342.56


-- Which branch sold more products than average product sold?
SELECT 
    Branch,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY Branch
HAVING SUM(Quantity) > (
    SELECT AVG(Quantity) FROM sales
)
ORDER BY Total_Quantity DESC;
-- Output sample:
-- A 1859
-- C 1831
-- B 1820


-- What is the most common product line by gender?
select Gender,
Product_line,
count(Product_line) as total_count
from sales
group by Gender, Product_line
ORDER BY total_count DESC;
-- Output sample (excerpt):
-- Female  Fashion accessories 96
-- Female  Food and beverages  90
-- Male    Health and beauty   88
-- Female  Sports and travel   88
-- Male    Electronic accessories 86
-- ...


-- What is the average rating of each product line?
select 
Product_line,
round (avg(Rating),2) as avg_Rating
from sales
group by Product_line
ORDER BY avg_Rating DESC;
-- Output sample:
-- Food and beverages    7.11
-- Fashion accessories   7.03
-- Health and beauty     7.00
-- Electronic accessories 6.92
-- ...


-- Number of sales made in each time of the day per weekday (exclude weekends)
select 
day_name,
Time_of_day,
count(Invoice_ID)
from sales
where day_name not in ('Saturday','Sunday')
group by day_name,Time_of_day
order by day_name, Time_of_day;
-- Output sample (excerpt):
-- Friday    Afternoon 58
-- Monday    Afternoon 48
-- Thursday  Afternoon 49
-- Tuesday   Afternoon 53
-- Wednesday Afternoon 61
-- Friday    Evening   52
-- ... etc


-- Identify the customer type that generates the highest revenue.
select 
Customer_type,
round(sum(Total),2) as total_sales
from sales
group by Customer_type
ORDER BY total_sales DESC;
-- Output sample:
-- Member 164223.44
-- Normal 158743.31


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
City,
round(sum(Tax_5),2) as total_Tax
from sales
group by City
ORDER BY total_Tax DESC;
-- Output sample:
-- Naypyitaw 5265.18
-- Yangon    5057.16
-- Mandalay  5057.03


-- Which customer type pays the most in VAT?
select 
Customer_type,
round(sum(Tax_5),2) as total_sales
from sales
group by Customer_type
ORDER BY total_sales DESC;
-- Output sample:
-- Member 7820.16
-- Normal 7559.21


-- How many unique customer types does the data have?
SELECT
COUNT(DISTINCT customer_type)
FROM sales;
-- Output sample:
-- 2


-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM sales;
-- Output sample:
-- 3


-- Which is the most common customer type?
SELECT customer_type,
COUNT(customer_type) AS common_customer
FROM sales
GROUP BY customer_type 
ORDER BY common_customer DESC ;
-- Output sample:
-- Member 501
-- Normal 499


-- Which customer type buys the most?
SELECT customer_type,
Round(SUM(total),2) as total_sales
FROM sales 
GROUP BY customer_type 
ORDER BY total_sales DESC;
-- Output sample:
-- Normal 158743.31
-- Member 164223.44


-- What is the gender of most of the customers?
SELECT Gender, 
COUNT(*) as all_genders 
FROM sales 
GROUP BY Gender 
ORDER BY all_genders DESC;
-- Output sample:
-- Female 501
-- Male   499


-- What is the gender distribution per branch?
SELECT 
Branch,
Gender,
COUNT(*) as all_genders 
FROM sales 
GROUP BY Branch,Gender 
ORDER BY Branch;
-- Output sample:
-- A Female 161
-- A Male   179
-- B Female 162
-- B Male   170
-- C Female 178
-- C Male   150


-- Which time of the day do customers give most ratings?
SELECT 
Time_of_day,
round(avg(Rating),2)  
FROM sales 
GROUP BY Time_of_day;
-- Output sample:
-- Morning   6.96
-- Evening   6.93
-- Afternoon 7.03


-- Which time of the day do customers give most ratings per branch?
SELECT 
Branch,
Time_of_day,
round(avg(Rating),2)   
FROM sales 
GROUP BY Time_of_day, Branch
order by Branch;
-- Output sample (excerpt):
-- A Afternoon 7.19
-- A Evening   6.89
-- A Morning   7.01
-- B Afternoon 6.84
-- ... etc


-- Which day of the week has the best avg ratings?
SELECT day_name,
round(avg(Rating),2) as average_rating 
FROM sales 
GROUP BY day_name
ORDER BY average_rating DESC;
-- Output sample:
-- Monday 7.15
-- Friday 7.08
-- Sunday 7.01
-- Tuesday 7.00
-- Saturday 6.90
-- Thursday 6.89
-- Wednesday 6.81


-- Which day of the week has the best average ratings per branch?
SELECT day_name, Branch, round(avg(Rating),2) as average_rating 
FROM sales 
GROUP BY day_name,Branch
ORDER BY Branch DESC;
-- Output sample: (as in your sample data)


-- ---------------- Analysis Queries ----------------

-- Monthly Revenue by Product Line with Running Total
WITH s AS (
    SELECT 
        Month_name,
        Product_line,
        ROUND(SUM(Total), 2) AS Total_revenue
    FROM sales
    GROUP BY Product_line, Month_name
)
SELECT 
    Month_name,
    Product_line,
    Total_revenue,
    SUM(Total_revenue) OVER (PARTITION BY Month_name ORDER BY Product_line) AS Running_Total
FROM s
ORDER BY Month_name, Product_line;
-- Output sample (excerpt):
-- February Electronic accessories 17362.9 17362.9
-- February Fashion accessories    19009.86 36372.76
-- February Food and beverages     20000.36 56373.12
-- February Health and beauty      14602.26 70975.38
-- February Home and lifestyle     12434.38 83409.76
-- February Sports and travel      13809.61 97219.37
-- January Electronic accessories  18831.29 18831.29
-- January Fashion accessories     19345.12 38176.41
-- January Food and beverages      19570.53 57746.94
-- January Health and beauty       16383.17 74130.11
-- January Home and lifestyle      20494.74 94624.85
-- January Sports and travel       21667.02 116291.87
-- March Electronic accessories    18143.34 18143.34
-- March Fashion accessories       15950.92 34094.26
-- March Food and beverages        16573.96 50668.22
-- March Health and beauty         18208.31 68876.53
-- March Home and lifestyle        20932.79 89809.32
-- March Sports and travel         19646.19 109455.51


-- Product Line Performance Compared to Global Average
WITH product_avg AS (
    SELECT 
        Product_line,
        ROUND(AVG(Total), 2) AS avg_Revenue_per_line
    FROM sales
    GROUP BY Product_line
)
SELECT 
    p.Product_line,
    p.avg_Revenue_per_line,
    ROUND(g.global_avg, 2) AS overall_avg_profit,
    CASE 
        WHEN p.avg_Revenue_per_line > g.global_avg THEN 'Above Avg'
        WHEN p.avg_Revenue_per_line < g.global_avg THEN 'Below Avg'
        ELSE 'Average'
    END AS Performance_Category
FROM product_avg p
CROSS JOIN (
    SELECT AVG(Total) AS global_avg FROM sales
) g
ORDER BY p.avg_Revenue_per_line DESC;
-- Output sample (excerpt):
-- Home and lifestyle    336.64 322.97 Above Avg
-- Sports and travel     332.07 322.97 Above Avg
-- Health and beauty     323.64 322.97 Above Avg
-- Food and beverages    322.67 322.97 Below Avg
-- Electronic accessories319.63 322.97 Below Avg
-- Fashion accessories   305.09 322.97 Below Avg


-- Daily Revenue Trend with Running Total
WITH s AS (
    SELECT 
        [Date],
        ROUND(SUM(Total), 2) AS Total_revenue
    FROM sales
    GROUP BY [Date]
)
SELECT 
    [Date],
    Total_revenue,
    SUM(Total_revenue) OVER (ORDER BY [Date]) AS Running_Total
FROM s
ORDER BY [Date];
-- Output sample (excerpt):
-- 2019-01-01 4745.18 4745.18
-- 2019-01-02 1945.5 6690.68
-- 2019-01-03 2078.13 8768.81
-- ... (continues as in your sample)


-- Ranking Product Lines by Total Sales
SELECT
    Product_line,
    COUNT(DISTINCT Invoice_ID) AS total_orders,
    SUM(Total) AS total_sales,
    RANK() OVER (ORDER BY SUM(Total) DESC) AS sales_rank
FROM sales 
GROUP BY Product_line;
-- Output sample (excerpt):
-- Food and beverages    174 56144.8439311981 1
-- Sports and travel     166 55122.8265810013 2
-- Electronic accessories170 54337.531457901  3
-- Fashion accessories   178 54305.8951845169 4
-- Home and lifestyle    160 53861.9131307602 5
-- Health and beauty     152 49193.7389202118 6


-- Hourly Revenue and Rank by Time of Day
SELECT 
    DATENAME(HOUR, [Time]) AS Hours,
    ROUND(SUM(Total), 2) AS Total_Revenue,
    RANK() OVER (ORDER BY ROUND(SUM(Total), 2) DESC) AS Revenue_Rank
FROM sales
GROUP BY DATENAME(HOUR, [Time]);
-- Output sample (excerpt):
-- 19 39699.51 1
-- 13 34723.23 2
-- 10 31421.48 3
-- 15 31179.51 4
-- 14 30828.4 5
-- 11 30377.33 6


-- Number of Orders by Time of Day
SELECT 
    Time_of_day,
    COUNT(*) AS Order_Count
FROM sales
GROUP BY Time_of_day
ORDER BY COUNT(*) DESC;
-- Output sample:
-- Evening   432
-- Afternoon 377
-- Morning   191


-- Daily Gross Income with Running Total and Average
WITH p AS (
    SELECT 
        [Date],
        SUM(gross_income) AS Total_gross_income
    FROM sales
    GROUP BY [Date]
)
SELECT 
    f.[Date],
    f.Total_gross_income,
    SUM(f.Total_gross_income) OVER (ORDER BY [Date]) AS Running_Total,
    AVG(s.Total_Avg_gross_income) OVER () AS AVG_gross_income
FROM p AS f
CROSS JOIN (
    SELECT AVG(gross_income) AS Total_Avg_gross_income FROM sales
) s;
-- Output sample (excerpt):
-- 2019-01-01 225.960999488831 225.960999488831 15.3793689970374
-- 2019-01-02 92.6430003643036 318.603999853134 15.3793689970374
-- 2019-01-03 98.9584982395172 417.562498092651 15.3793689970374
-- ... (continues as in your sample)


-- Quantity Sold by Product Line and Month
SELECT 
    Product_line,
    Month_name,
    SUM(Quantity) AS Total_QTY
FROM sales
GROUP BY Product_line, Month_name
ORDER BY Month_name;
-- Output sample (excerpt):
-- Electronic accessories February 313
-- Fashion accessories     February 295
-- Food and beverages      February 349
-- Health and beauty       February 266
-- Home and lifestyle      February 205
-- Sports and travel       February 226
-- Electronic accessories January 333
-- Fashion accessories     January 336
-- ... (continues as in your sample)
