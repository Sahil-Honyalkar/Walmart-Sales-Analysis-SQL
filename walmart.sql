create database walmart;

use walmart;

create table sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time TIME not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1));

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------- 	Feature Engineering ------------------------------------------------------------------------------

-- time of the day

select time,
(Case
 when time between "00:00:00" and "12:00:00" then "Morning"
 when time between "12:01:00" and "16:00:00" then "Afternoon"
 else "Evening"
 end) as TIME_OF_DATE from sales;
 
 alter table sales add column TIME_OF_DAY varchar(20);
 
 update sales
 set TIME_OF_DAY = (Case
 when time between "00:00:00" and "12:00:00" then "Morning"
 when time between "12:01:00" and "16:00:00" then "Afternoon"
 else "Evening"
 end);
 
 -- day_name
 
 select date,dayname(date) as day_name from sales;
 
 alter table sales add column DAY_NAME varchar(10);
 
 update	sales
 set DAY_NAME = dayname(date);
 
 -- month_name
 
 select date,monthname(date) from sales;
 
 alter table sales add column MONTH_NAME varchar(20);
 
 update sales set MONTH_NAME = monthname(date);
	
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
-- ------------------------------------------------------------------------------- 	Generic Questions ------------------------------------------------------------------------------

SELECT DISTINCT
    (city)
FROM
    sales;

SELECT DISTINCT
    (branch)
FROM
    sales;

select distinct city,branch from sales;
 
 -- ------------------------------------------------------------------------------- Product Questions ------------------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;

-- What is the most common payment method?
select payment_method,count(payment_method) as CNT from sales group by payment_method order by CNT desc;

-- What is the most selling product line?
select product_line,count(product_line) as CNT from sales group by product_line order by CNT desc;

-- What is the total revenue by month?
select MONTH_NAME as MONTH,sum(total) as total_revenue from sales group by MONTH order by total_revenue desc;

-- What month had the largest COGS?
select month_name,sum(cogs) as COGS from sales group by month_name order by COGS desc;

-- What product line had the largest revenue?
select product_line,sum(total) as revenue from sales group by product_line order by revenue desc;

-- What is the city with the largest revenue?
select branch,city,sum(total) as revenue from sales group by branch,city order by revenue desc;

-- What product line had the largest VAT?
select product_line,avg(VAT) as Vat from sales group by product_line order by Vat desc ;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
-- Which branch sold more products than average product sold?
select branch,sum(quantity) as qty from sales group by branch having sum(quantity)>(select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender,product_line,count(gender) as CNT from sales group by gender,product_line order by CNT desc;

-- What is the average rating of each product line?
select product_line,round(avg(rating),2) as RATING from sales group by product_line order by RATING desc;
 
 -- ------------------------------------------------------------------------------- Sales Questions ------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
select TIME_OF_DAY,count(*) as Total_Sales from sales where DAY_NAME='Wednesday'group by TIME_OF_DAY order by Total_Sales desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as revenue from sales group by customer_type order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(VAT) as max_vat from sales group by city order by max_vat desc;

-- Which customer type pays the most in VAT?
select customer_type,avg(VAT) as max_vat from sales group by customer_type order by max_vat desc;
 
  -- ------------------------------------------------------------------------------- Customer Questions ------------------------------------------------------------------------------
-- How many unique customer types does the data have?
select distinct customer_type from sales;

-- How many unique payment methods does the data have?
select distinct payment_method from sales;

-- What is the most common customer type?
select customer_type,count(customer_type) as customer from sales group by customer_type order by customer desc limit 1;

-- Which customer type buys the most?
select customer_type,count(customer_type) as customer from sales group by customer_type order by customer desc limit 1;

-- What is the gender of most of the customers?
select gender,count(customer_type) as customer from sales group by gender order by customer desc limit 1;

-- What is the gender distribution per branch?
select branch,gender,count(*) as distribution from sales group by branch,gender;

-- Which time of the day do customers give most ratings?
select TIME_OF_DAY,avg(rating) as avg_rating from sales group by TIME_OF_DAY order by avg_rating desc limit 1;

-- Which time of the day do customers give most ratings per branch?
select branch,TIME_OF_DAY,avg(rating) as avg_rating from sales where branch='B' group by branch,TIME_OF_DAY order by avg_rating desc limit 1;

-- Which day fo the week has the best avg ratings?
select DAY_NAME,avg(rating) as avg_ratings from sales group by DAY_NAME order by avg_ratings desc limit 1;

-- Which day of the week has the best average ratings per branch?
select DAY_NAME,branch,avg(rating) as avg_ratings from sales group by DAY_NAME,branch order by avg_ratings desc limit 1
 


