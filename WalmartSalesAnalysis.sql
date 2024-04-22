CREATE DATABASE IF NOT EXISTS WalmartSalesData;

USE WalmartSalesData;

CREATE TABLE IF NOT EXISTS Sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_percentage DECIMAL(10,2) NOT NULL,
gross_income FLOAT(11,9) ,
rating FLOAT(2,1)
);

SELECT * FROM Sales;

--- Data Cleaning
--- Check Up Null values There is no NULL values

--- Feature Engineering
--- Add time_of_day column
ALTER TABLE Sales
ADD COLUMN time_of_day VARCHAR(30);

--- Add dayname column
ALTER TABLE Sales
ADD COLUMN dayname VARCHAR(10);

--- Add monthname column
ALTER TABLE Sales
ADD COLUMN monthname VARCHAR(10);

--- Update values in to the new columns
UPDATE Sales
SET time_of_day = (
CASE WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
     WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "afternoon"     
     ELSE "Evening"
END
);

SELECT time, time_of_day 
FROM Sales;

--- Update dayname column
UPDATE Sales 
SET dayname = DAYNAME(date);

SELECT date,dayname 
FROM Sales;

--- Update monthname column
UPDATE Sales
SET monthname = MONTHNAME(date);

SELECT date,monthname 
FROM Sales;

--- Exploratory data analysis
--- How many unique cities in the dataset
SELECT COUNT(DISTINCT city)
FROM Sales;

--- what are the unique city names
SELECT DISTINCT city 
FROM Sales;

--- What are the unique branches in each city
SELECT DISTINCT branch,city 
FROM Sales;

--- Product based analysis
--- How many unique product line present in the dataset?
SELECT COUNT(DISTINCT product_line)
FROM Sales;

--- What is the most selling product line?
SELECT product_line,COUNT(product_line) AS most_selling_product
FROM Sales
GROUP BY product_line
ORDER BY most_selling_product DESC;

--- What is the most common payment method?
SELECT payment_method, COUNT(payment_method) AS common_payment_method
FROM Sales
GROUP BY payment_method
ORDER BY common_payment_method;

--- What is the total revenue by month?
SELECT monthname AS month, ROUND(SUM(total),2) AS total_revenue
FROM Sales
GROUP BY monthname
ORDER BY total_revenue DESC;

--- Which product line had the largest VAT?
SELECT product_line, ROUND(AVG(VAT),2) AS largest_VAT
FROM Sales
GROUP BY product_line
ORDER BY largest_VAT DESC;

--- City with most revenue
SELECT city,branch, ROUND(SUM(total),2) AS total_revenue
FROM Sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

--- product line with most revenue
SELECT product_line, ROUND(SUM(total),2) AS total_revenue
FROM Sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--- Which branch sold more products than average product sold?
SELECT branch,SUM(quantity) AS total_quanitity 
FROM Sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

--- Purchases based on gender and product line
SELECT gender,product_line,COUNT(quantity) AS total_purchase
FROM Sales
GROUP BY gender,product_line
ORDER BY total_purchase DESC;

--- Customer analysis
--- How many unique customer types
SELECT COUNT(DISTINCT customer_type) AS unique_cust_type
FROM Sales;

--- How many unique payment methods?
SELECT COUNT(DISTINCT payment_method) AS unique_payment_method
FROM Sales;

--- Most common customer type
SELECT customer_type, COUNT(customer_type) AS common_cust_type
FROM Sales
GROUP BY customer_type
ORDER BY common_cust_type DESC;

--- Which customer type purchased more items based on gender?
SELECT customer_type, gender,COUNT(*) AS most_buyer
FROM Sales
GROUP BY customer_type,gender
ORDER BY most_buyer DESC LIMIT 1;

--- What is the gender distribution for branch?
SELECT branch,gender, COUNT(gender) AS gender_dist
FROM Sales
GROUP BY branch,gender
ORDER BY branch DESC;

--- Which time of the day do customer give most rating?
SELECT time_of_day,ROUND(AVG(rating),2) AS avg_rating
FROM Sales
GROUP BY time_of_day
ORDER BY avg_rating  DESC;

--- Which day of the week has the best average rating?
SELECT dayname, CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM Sales
GROUP BY dayname
ORDER BY avg_rating DESC;

--- Which day of the week has the best avg rating per branch?
SELECT branch,dayname,CAST(AVG(rating) AS DECIMAL(10,2))AS avg_rating
FROM  Sales
GROUP BY dayname,branch
ORDER BY avg_rating DESC;












