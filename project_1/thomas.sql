
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
