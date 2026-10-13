-- ==========================================
-- SQL DATA ANALYSIS (LILY REVISED & FIXED SCRIPT)
-- ==========================================

-- @Data exploration
USE MyDatabase;

--- DATA OVERVIEW

-- Identifying the columns
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'wenge_table';

-- Identifying the total number of rows
SELECT COUNT(*) AS total_rows 
FROM wenge_table;

-- Identifying sample rows from the wenge_table
SELECT TOP 10 * FROM wenge_table;
SELECT TOP 20 * FROM wenge_table;

-- Identifying the null values
SELECT COUNT(CASE WHEN ProjectID IS NULL THEN 1 ELSE 0 END) AS missing_projectIDS,
       COUNT(CASE WHEN ClientID IS NULL THEN 1 ELSE 0 END) AS missing_clientIDS,
       COUNT(CASE WHEN ProjectName IS NULL THEN 1 ELSE 0 END) AS missing_projectNames,
       COUNT(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_department,
       COUNT(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_Region,
       COUNT(CASE WHEN ProjectDate IS NULL THEN 1 ELSE 0 END) AS missing_projectDate,
       COUNT(CASE WHEN HoursWorked IS NULL THEN 1 ELSE 0 END) AS missing_hoursworked,
       COUNT(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS missing_revenues,
       COUNT(CASE WHEN ProJECTManager IS NULL THEN 1 ELSE 0 END) AS missing_manager,
       COUNT(CASE WHEN Status IS NULL THEN 1 ELSE 0 END) AS missing_status
FROM wenge_table;

-- Identifying the duplicates (duplicated values)
SELECT DISTINCT TOP 10 * FROM wenge_table;
SELECT DISTINCT ProjectID, ClientID FROM wenge_table;

SELECT COUNT(*) AS total_records,
       COUNT(ClientID) as total_client 
FROM wenge_table
GROUP BY ProjectID, ClientID
HAVING COUNT(*) > 1;


--- BIVARIATE ANALYSIS
-- @Analysing the department & revenue
SELECT Department, SUM(Revenue) as total_revenue_department
FROM wenge_table
GROUP BY Department;

-- @Identifying the region & revenue 
SELECT Region, SUM(Revenue) as total_revenue_per_region
FROM wenge_table
GROUP BY Region;

-- Identifying the total hours and revenue per each department
SELECT Department, SUM(Revenue) total_revenue, SUM(HoursWorked) as total_hours
FROM wenge_table
GROUP BY Department;

-- Identifying the total hours and revenue per each region
SELECT Region, SUM(Revenue) total_revenue, SUM(HoursWorked) as total_hours
FROM wenge_table
WHERE Region != 'not eixt'
GROUP BY Region
ORDER BY SUM(Revenue) DESC;


--- MULTIVARIATE ANALYSIS
-- @Identifying the Department, Region, Revenue, Hours
SELECT Department, Region, 
       SUM(Revenue) as total_revenue,
       SUM(HoursWorked) as total_hours,
       AVG(Revenue) as AVG_revenue,
       AVG(HoursWorked) as avg_hours
FROM wenge_table
GROUP BY Department, Region;

-- @Find the region, department, total revenue, average revenue, and total records
SELECT Region, Department, 
       SUM(Revenue) total_revenue,
       AVG(Revenue) as avg_revenue,
       COUNT(*) as total_records
FROM wenge_table
GROUP BY Region, Department
ORDER BY Region;


--- RECOMMENDATIONS AND INSIGHTS (Notes)
--- The data are about projects that have a total of 46 records and they contain no duplicates and null values. 
--- The total revenue tends to change over time and varies per department in different regions. 
--- The South region has higher revenue than other regions, so the company should keep effort on other regions to facilitate production and increase productivity.


--- ADVANCED ANALYSIS

-- @COMPARISON ANALYSIS (Fixed Month-over-Month percentage change)
SELECT 
       Department,
       Region,
       MONTH(ProjectDate) as project_month,
       SUM(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate) DESC) as total_revenue,
       AVG(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate) DESC) as avg_revenue,
       LAG(Revenue) OVER (ORDER BY MONTH(ProjectDate)) as revenue_previous_month,
       Revenue,
       Revenue - LAG(Revenue) OVER (ORDER BY MONTH(ProjectDate)) AS revenue_difference,
       Revenue - AVG(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate) DESC) AS Variation_revenue,
       CONCAT(ROUND((Revenue - LAG(Revenue) OVER (ORDER BY MONTH(ProjectDate))) * 1.0 / NULLIF(LAG(Revenue) OVER (ORDER BY MONTH(ProjectDate)), 0), 2) * 100, '%') AS percentage_change_previous_revenue,
       CASE 
       WHEN (Revenue - LAG(Revenue) OVER (ORDER BY MONTH(ProjectDate))) > 0 THEN 'changed_positively' 
       ELSE 'changed_negatively' 
       END AS classification
FROM wenge_table
ORDER BY MONTH(ProjectDate);


-- @RANKING ANALYSIS (Revenue < Total Revenue)
WITH Ranking_analysis AS (
SELECT Department, Region, Revenue,
       SUM(Revenue) OVER() as total_revenue,
       AVG(Revenue) OVER() AS avg_revenue,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) as ordered_revenue_by_department
FROM wenge_table
)
SELECT * FROM Ranking_analysis
WHERE Revenue < total_revenue;


-- @RANKING ANALYSIS (Revenue > Total Revenue)
WITH Ranking_analysis AS (
SELECT Department, Region, Revenue,
       SUM(Revenue) OVER() as total_revenue,
       AVG(Revenue) OVER() AS avg_revenue,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) as ordered_revenue_by_department
FROM wenge_table
)
SELECT * FROM Ranking_analysis
WHERE Revenue > total_revenue;


-- @RANKING ANALYSIS (Revenue < Average Revenue)
WITH Ranking_analysis AS (
SELECT Department, Region, Revenue,
       SUM(Revenue) OVER() as total_revenue,
       AVG(Revenue) OVER() AS avg_revenue,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) as ordered_revenue_by_department
FROM wenge_table
)
SELECT * FROM Ranking_analysis
WHERE Revenue < avg_revenue;


-- @RANKING ANALYSIS (Revenue > Average Revenue)
WITH Ranking_analysis AS (
SELECT Department, Region, Revenue,
       SUM(Revenue) OVER() as total_revenue,
       AVG(Revenue) OVER() AS avg_revenue,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) as ordered_revenue_by_department
FROM wenge_table
)
SELECT * FROM Ranking_analysis
WHERE Revenue > avg_revenue;


--- TIME SERIES ANALYSIS
-- @Determine the change in revenue per month
SELECT MONTH(ProjectDate) as project_month,
       SUM(Revenue) as total_project_revenue,
       AVG(Revenue) as avg_revenue
FROM wenge_table
GROUP BY MONTH(ProjectDate)
ORDER BY MONTH(ProjectDate) ASC;


--- CONTRIBUTION / PERCENTAGE ANALYSIS (Fixed average comparison percentage)
SELECT Department, 
       Revenue,
       SUM(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) as total_revenue,
       Revenue - LAG(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate)) AS change_revenue_previous_month,
       CONCAT(ROUND(Revenue * 1.0 / (SUM(Revenue) OVER(PARTITION BY Department ORDER BY MONTH(ProjectDate))), 2) * 100, '%') as percantage_change_contribution,
       --- Target (AVERAGE REVENUE)
       AVG(Revenue) OVER() as avg_revenue,
       Revenue - AVG(Revenue) OVER() AS revenue_variation,
       CONCAT(ROUND((Revenue - AVG(Revenue) OVER()) * 1.0 / NULLIF(AVG(Revenue) OVER(), 0), 2) * 100, '%') as percantage_change_from_avg
FROM wenge_table;


--- COHORT & RETENTION ANALYSIS
WITH firstprojectcohort AS (
SELECT 
    ProjectID,
    ProjectDate,
    MIN(DATETRUNC(MONTH, ProjectDate)) OVER(PARTITION BY ProjectID) as cohort_month,
    DATEDIFF(MONTH, MIN(DATETRUNC(MONTH, ProjectDate)) OVER(PARTITION BY ProjectID), DATETRUNC(MONTH, ProjectDate)) as month_diffrence
FROM wenge_table
)
SELECT cohort_month,
    -- Determine the total customers of the cohort month
    COUNT(DISTINCT CASE WHEN month_diffrence = 0 THEN ProjectID END) as total_cohort_projects,
    -- Determine the projects done per each month followed after cohort month
    COUNT(DISTINCT CASE WHEN month_diffrence = 1 THEN ProjectID END) as total_month1_projects,
    COUNT(DISTINCT CASE WHEN month_diffrence = 2 THEN ProjectID END) as total_month2_projects,
    COUNT(DISTINCT CASE WHEN month_diffrence = 3 THEN ProjectID END) as total_month3_projects,
    COUNT(DISTINCT CASE WHEN month_diffrence = 4 THEN ProjectID END) as total_month4_projects,
    CONCAT(ROUND((COUNT(DISTINCT CASE WHEN month_diffrence = 1 THEN ProjectID END)) * 100.0 / NULLIF((COUNT(DISTINCT CASE WHEN month_diffrence = 0 THEN ProjectID END)), 0), 2), '%') As retention_rate
FROM firstprojectcohort
GROUP BY cohort_month
ORDER BY cohort_month;
