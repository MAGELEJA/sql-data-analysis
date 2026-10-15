
--identifying the database & the tables found in with the related table (required table)

--EXPLORATORY ANALYSIS
USE MyDatabase
SELECT * FROM INFORMATION_SCHEMA.TABLES
select * from CUSTOMER_SALE_TABLE
         --DATA OVERVIEW
---identifying the table 
SELECT * FROM CUSTOMER_SALE_TABLE
--understanding the data in the table
---from the identification the data in the table involve the order data whicha have the type of category and the revenue of each product ordered
--@checking the size of the data
SELECT COUNT(*) AS total_row FROM CUSTOMER_SALE_TABLE
--from above the data or tha table have 5000 records or rows
  --cheking the each columns  and determine if have meaning 
  SELECT DISTINCT * FROM CUSTOMER_SALE_TABLE
  SELECT DISTINCT order_id,customer_id FROM CUSTOMER_SALE_TABLE
  --cheking the null values and handling them 

  SELECT COUNT(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as non_order_ids,
         COUNT(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) as non_order_date ,
         COUNT(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as non_customer,
         COUNT(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) as non_products_category,
         COUNT(CASE WHEN region IS NULL THEN 1 ELSE 0 END) as non_regions,
         COUNT(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) as non_quantity,
         COUNT(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) as non_unit_price,
         COUNT(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) as non_discount,
         COUNT(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) as non_payement_method,
         COUNT(CASE WHEN delivery_days IS NULL THEN 1 ELSE 0 END) as null_delivery_days,
         COUNT(CASE WHEN customer_rating IS NULL THEN 1 ELSE 0 END) as non_customer_rating,
         COUNT(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) as non_revenues
FROM CUSTOMER_SALE_TABLE
--From the above there are not any null record so no null values

--@cheking the duplicates

SELECT DISTINCT False as unique_false,
COUNT(False) as total_records 
FROM  CUSTOMER_SALE_TABLE
GROUP BY False
HAVING COUNT(False)>1


SELECT DISTINCT order_id as unique_order_ids,
COUNT(order_id) as total_records 
FROM  CUSTOMER_SALE_TABLE
GROUP BY order_id
HAVING COUNT(order_id)>1

SELECT DISTINCT customer_id as unique_customers,
COUNT(customer_id) as total_records 
FROM  CUSTOMER_SALE_TABLE
GROUP BY customer_id
HAVING COUNT(customer_id)>1

SELECT order_id,customer_id,
ROW_NUMBER() OVER (  PARTITION BY customer_id,order_id ORDER BY customer_id,order_id) as num_row
FROM CUSTOMER_SALE_TABLE

SELECT DISTINCT customer_id,COUNT(customer_id) FROM CUSTOMER_SALE_TABLE
GROUP BY customer_id

--from above indicates that there are some customer who ordered than one order hence seem like that there duplcated customer

---@checking the datatypes

SELECT COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='CUSTOMER_SALE_TABLE'
---From above it indicates that the datatype are correctly 

--UNIVARIATE ANALYSIS
    --@Determine the revenue per each product_category
    select * from CUSTOMER_SALE_TABLE

    SELECT product_category,SUM(revenue) AS total_revenue,SUM(unit_price) as total_unit_price
    FROM CUSTOMER_SALE_TABLE
    GROUP BY product_category
    ---BINARY VARIATE ANALYSIS & multivariate_analysis

---@determine the number of product_category in each region
SELECT region, product_category,COUNT(product_category) as total_product_category_region,
       SUM(Revenue) as total_revenue
FROM CUSTOMER_SALE_TABLE
GROUP BY region,product_category
ORDER BY SUM(Revenue) DESC

--there are diffrent number of product_category in each region which indicates that some
--of the regions produces many products than others Examples the south region produces more than revenue caused by many products so the sales 
--become also hgher followed by north as analysed so east country with product beauty get low revenue and the total number of products,
--here indicates that there must increasing the number of products in the region that produces low revenue

--ADVANCED ANALYSIS

--@comparison alaysis

SELECT 
    MONTH(order_date) AS order_month,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue,
    -- Hapa tunachukua SUM(revenue) ya mwezi uliopita
    LAG(SUM(revenue), 1) OVER(ORDER BY MONTH(order_date)) AS previous_month_revenue
FROM CUSTOMER_SALE_TABLE
GROUP BY MONTH(order_date) --
ORDER BY order_month ASC;

---@compare the revenue on the current revenue and the previous_month revenue to see the growth(revenue) or decrease

SELECT MONTH(order_date) as order_date,
       SUM(revenue) as total_revenue,
       LAG(SUM(revenue)) OVER (ORDER BY MONTH(order_date)) as previous_month_revenue,
       SUM(revenue)- LAG(SUM(revenue)) OVER (ORDER BY MONTH(order_date)) as difference_revenue,
     CONCAT(ROUND(  (NULLIF(SUM(revenue)- LAG(SUM(revenue)) OVER (ORDER BY MONTH(order_date)),0))*1.0/NULLIF( LAG(SUM(revenue)) OVER (ORDER BY MONTH(order_date)),0),2)*100,'%')as revenue_perentage
FROM CUSTOMER_SALE_TABLE
GROUP BY MONTH(order_date) 
ORDER BY MONTH(order_date)

--from the above the analysis ndicates that some of the months have postively change on revenue example on april month there have higher change on
--revenue than on other month followed by july,februaryy ,october and november respectively where some months experiencing to have low revenue change
--example on october ,may,march expoerinced to have low revenue change where there must be more production by increasing the number of labousr

--RANKING ANALYSIS
WITH ranking_analysis AS (
SELECT order_id,customer_id,product_category,
       DENSE_RANK() OVER (PARTITION BY order_id,customer_id ORDER BY MONTH(order_date)) as ordered_customer,
       ROW_NUMBER() OVER(PARTITION BY order_id,customer_id ORDER BY MONTH(order_date)) as ordered_customers
FROM CUSTOMER_SALE_TABLE
)
SELECT * FROM ranking_analysis

--CONTRIBUTION /PERCANTAGE ANALYSIS
WITH contribution_change_one AS(
SELECT product_category,revenue,
       SUM(revenue) OVER()as total_revenue,
       AVG(revenue)OVER() as avg_revenue,
       revenue- AVG(revenue)OVER() as variation,
       CONCAT( ROUND((revenue- AVG(revenue)OVER())*1.0/( AVG(revenue)OVER()),2)*100,'%') as variation_percentage
FROM CUSTOMER_SALE_TABLE
)
SELECT *,
CONCAT(ROUND((revenue)*1.0/(total_revenue),5)*100,'%') as revenue_contribution_percantage
FROM contribution_change_one
 
---From the above analysis the values contribution on revenue per whole revenue is seem to be low that indicates that 
---the revenue produced is low as compared to the whole revenue and the variation is ted to change 

----COHORT AND RETENTION ANALYSIS
 WITH first_cohort_customers AS (
SELECT 
   customer_id,
   --FIND THE COHORT MONTH
  MIN( DATETRUNC(MONTH,order_date)) OVER(PARTITION BY customer_id) as cohort_month,
  ---FND THE DIFFRENCE IN COHORT MONTH & NEXT_MONTHS
   DATEDIFF(MONTH,MIN( DATETRUNC(MONTH,order_date)) OVER(PARTITION BY customer_id),DATETRUNC(MONTH,order_date)) as months_diffrence
FROM CUSTOMER_SALE_TABLE
)

SELECT
      cohort_month,
   --DETERMINE THE TOTAL NEW CUSTOMER

   COUNT(DISTINCT CASE WHEN months_diffrence=0 THEN customer_id END) as total_cohort_customers,
   ---DETERMINE THE RETURNED CUSTOMERS ON COMING MONTHS

   COUNT(DISTINCT CASE WHEN months_diffrence=1 THEN customer_id END) as cohort_customer1,
   COUNT(DISTINCT CASE WHEN months_diffrence=2 THEN customer_id END) as cohort_customer2,
   COUNT(DISTINCT CASE WHEN months_diffrence=3 THEN customer_id END) as cohort_customer3,
   COUNT(DISTINCT CASE WHEN months_diffrence=4 THEN customer_id END) as cohort_customer4,
   COUNT(DISTINCT CASE WHEN months_diffrence=5 THEN customer_id END) as cohort_customer5,
   COUNT(DISTINCT CASE WHEN months_diffrence=6 THEN customer_id END) as cohort_customer6,
   COUNT(DISTINCT CASE WHEN months_diffrence=7 THEN customer_id END) as cohort_customer7,
   COUNT(DISTINCT CASE WHEN months_diffrence=8 THEN customer_id END) as cohort_customer8,
   COUNT(DISTINCT CASE WHEN months_diffrence=9 THEN customer_id END) as cohort_customer9,
   COUNT(DISTINCT CASE WHEN months_diffrence=10 THEN customer_id END) as cohort_customer10,
   COUNT(DISTINCT CASE WHEN months_diffrence=11 THEN customer_id END) as cohort_customer11,
   COUNT(DISTINCT CASE WHEN months_diffrence=12 THEN customer_id END) as cohort_customer12,
   ---DETERMINE THE RETENTION RATE

CONCAT(ROUND((COUNT(DISTINCT CASE WHEN months_diffrence=1 THEN customer_id END))*1.0/( COUNT(DISTINCT CASE WHEN months_diffrence=0 THEN customer_id END)),5)*100,'%') as retention_rate,
---find the churn rate

 CONCAT(  ROUND(
       100 - (
           (COUNT(DISTINCT CASE WHEN months_diffrence = 1 THEN customer_id END) * 1.0) / 
           NULLIF(COUNT(DISTINCT CASE WHEN months_diffrence = 0 THEN customer_id END), 0) * 100
       ), 
       2
   ),'%') as churn_rate_month1
 FROM first_cohort_customers
 GROUP BY cohort_month
 ORDER BY cohort_month

 ---From the analyses above the comparison on retention rate tend to varry from one month to another month 
 --where other month have rentetion rate of zero percentege indicating that no customer or low customer returning values
 --and other get 50 perent example with DATE ON 2028-07-01 00:00:00.0000000 get 50 percentage of retention indicating that some customer left and half of them returned 
 --to order this may be the kind of quality of products 













