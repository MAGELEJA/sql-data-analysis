USE MyDatabase

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM CUSTOMERS_TABLE

--UNDERSTANDING THE DATA FROM THE TABLE
 SELECT * FROM CUSTOMERS_TABLE
  ---From above the data are about the customers signed in the company and the cost used to get such customer

  SELECT TOP 10 * FROM  CUSTOMERS_TABLE
  SELECT COUNT(*) AS total_records FROM CUSTOMERS_TABLE

  SELECT COUNT( DISTINCT customer_id) AS total_unigue_customers,count(*) as total_records FROM CUSTOMERS_TABLE

  --LOOKING FOR DATA_TYPES OF EACH COLUMN

  SELECT COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME='CUSTOMERS_TABLE'

--from above the datatypes are correctly

SELECT customer_id,COUNT(customer_id) as total_recods_customers FROM CUSTOMERS_TABLE
group by customer_id
HAVING COUNT(customer_id)>1
--from abaove there is duplicates according to the analysis

SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as null_customers,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) as null_customer_names,
    SUM(CASE WHEN customer_age IS NULL THEN 1 ELSE 0 END) as null_customer_age,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) as null_customers_gender,
    SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) as null_customer_segments,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) as null_customer_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) as null_customer_state,
    SUM(CASE WHEN customer_country IS NULL THEN 1 ELSE 0 END) as null_customer_country,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) as null_customer_region
FROM CUSTOMERS_TABLE

---from the analysis above the data are not empty

--UNIVARIATE ANALYSIS

 ----@analysing the customer and the customer_acquistion

 SELECT customer_id,SUM(customer_acquisition_cost) as total_customer_acqustion_cost FROM CUSTOMERS_TABLE
 GROUP BY customer_id

 SELECT  customer_country,customer_segment FROM CUSTOMERS_TABLE
 GROUP BY customer_country,customer_segment
 ORDER BY customer_country
 --from the above analysis indicates that the customers of different category distributed differently from different countries
 --BINARY VARIATE ANALYSIS

 SELECT customer_name,gender,sum(customer_acquisition_cost) as total_acq_cost
 FROM CUSTOMERS_TABLE
 GROUP BY customer_name,gender

 SELECT gender,COUNT(gender) as total_gender_kind
 FROM CUSTOMERS_TABLE
 GROUP BY gender



 SELECT gender  FROM CUSTOMERS_TABLE 

 WHERE gender !='Male' AND gender!= 'Female'

 
 SELECT *,gender ,COUNT(*) OVER(PARTITION BY gender)AS total_records  FROM CUSTOMERS_TABLE 

 WHERE gender! ='Non-Binary'

--from the analysis above indicates that there are some non-binary gender (unkown gender) which are 976 in number
--and the rest are known gender (female and male)

---MULTI VARIATE ANALYSIS

SELECT region, customer_city,customer_country,COUNT(region) as total_region_in_city,SUM(customer_acquisition_cost) AS total_customer_cost
FROM CUSTOMERS_TABLE
GROUP BY customer_city,customer_country,region
ORDER BY region

--ADVANCED ANALYSIS

--comparison analysis

--@compare the total_customer_acquistion cost of customer per each region distributed in different cities and countries


SELECT region, customer_city,customer_country,COUNT(region) as total_region_in_city,SUM(customer_acquisition_cost) AS total_customer_cost
FROM CUSTOMERS_TABLE
GROUP BY customer_city,customer_country,region
ORDER BY region

SELECT region,customer_city,SUM(customer_acquisition_cost) OVER ()AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER() as avg_customer_cost
FROM CUSTOMERS_TABLE
--@compare the total_customer_acquistion cost of customer per each region distributed in different cities and countries
----Then group by regions

WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost
FROM CUSTOMERS_TABLE
)

SELECT * FROM  aggregating
WHERE customer_acquisition_cost> total_customer_cost


WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost
FROM CUSTOMERS_TABLE
)

SELECT * FROM  aggregating
WHERE customer_acquisition_cost< total_customer_cost

WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost
FROM CUSTOMERS_TABLE
)

SELECT * FROM  aggregating
WHERE customer_acquisition_cost> avg_customer_cost



WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost
FROM CUSTOMERS_TABLE
)

SELECT * 
FROM  aggregating
WHERE customer_acquisition_cost<avg_customer_cost

--from the analysis above there are some regions which get customer_acqustion cost that are higher than total_acq_customer_cost
--but not less than but also there some region which get lower customer-acq cost than the avg of the whole regions and the also the same for higher avg
---this shiw that there are some regions which  uses lower cost to get the  customers and others use higher  cost to  get the  customers


--RANKING ANALYSIS


WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost
FROM CUSTOMERS_TABLE
)

SELECT * ,
DENSE_RANK() OVER(ORDER BY customer_acquisition_cost DESC) AS ranked_customer
FROM  aggregating
WHERE customer_acquisition_cost<avg_customer_cost


WITH aggregating AS (
SELECT region,customer_city,customer_acquisition_cost,SUM(customer_acquisition_cost) OVER (PARTITION BY region)AS total_customer_cost,
      AVG(customer_acquisition_cost)OVER(partition by region) as avg_customer_cost,
      DENSE_RANK() OVER(partition by region ORDER BY customer_acquisition_cost DESC) AS ranked_customer,
      ROW_NUMBER()  OVER (partition by region ORDER BY customer_acquisition_cost DESC) as ordered_uniquely
FROM CUSTOMERS_TABLE
)

SELECT * 
FROM  aggregating
--From the analysis above it indicates that the regions  get customer-acq cost differently example the central region acquire 
--higher cost other regions followed by east regions here indicates that the company must balance to acquire or it caused by 
---difficultness in obtaining the customers which made the company to use high cost


--TIME SERIES ANALYSIS

SELECT customer_city,customer_age,CURRENT_TIMESTAMP as muda  FROM  CUSTOMERS_TABLE

---PERCENTAGE ANALYSIS 
WITH summation AS (

SELECT customer_city,customer_country,customer_acquisition_cost,
       SUM(customer_acquisition_cost)OVER () AS Total_acq_cost,
       customer_acquisition_cost-CAST(SUM(customer_acquisition_cost)OVER () AS FLOAT)as difference_customer_cost,
       customer_acquisition_cost-LAG(customer_acquisition_cost,1) OVER(ORDER BY customer_acquisition_cost)  as previous_acq_cost_difference,
    CONCAT( ROUND( ( customer_acquisition_cost-CAST(SUM(customer_acquisition_cost)OVER () AS FLOAT))*1.0/( SUM(customer_acquisition_cost)OVER () ) ,4)*100,'%') as percentage_change_cost,

 CONCAT(  ROUND( (customer_acquisition_cost-LAG(customer_acquisition_cost,1) OVER(ORDER BY customer_acquisition_cost))/NULLIF((LAG(customer_acquisition_cost,1) OVER(ORDER BY customer_acquisition_cost)),0),3)*100,'%') previous_cost_change
FROM CUSTOMERS_TABLE



)

SELECT *    
FROM summation

---From the analysis above it indicates that the customer in differently regions distributed in cities and countries differently aapear to have 
----low cost variation  of customer_acq cost hence because the variation is hundered percent and also the previous customer cost 
--have not high  cost acq because the change in percantage is small approaching to zero percantage 






