USE MyDatabase

SELECT * FROM INFORMATION_SCHEMA.TABLES

---Data overview
---(Identifying the size,top n data and understanding  the data)

 --understnading the data
SELECT * FROM wenge_table
 --data concerned the project data

 ---identifying the size and the top n of tha data

 SELECT TOP 10 * FROM wenge_table
 ---identfying the total_records of total_rows

 SELECT COUNT(*) as total_records FROM wenge_table

 --DATA CLEANING
 --identfying the data_types

SELECT COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='wenge_table'
--identufying the null values

SELECT COUNT(*) AS total_record_each_column,
COUNT(ProjectID) as total_ids,COUNT(ClientID) as total_id_client,COUNT(ProjectName) as project_name_total,
     COUNT(Department)as total_department,COUNT(Region) as total_regions,COUNT(ProjectDate) as total_date_records,
     COUNT(HoursWorked) as total_hours_worked,COUNT(Revenue) as total_records_revenue,COUNT(ProjectManager) as total_manager_records,
     COUNT(Status) as project_total_records_status

FROM wenge_table

--identfying null values

SELECT SUM(CASE WHEN 'ProjectID' IS NULL THEN 1 ELSE 0 END) as null_projectID,
       SUM(CASE WHEN 'ClientID' IS NULL THEN 1 ELSE 0 END) AS null_clientID,
       SUM(CASE WHEN 'ProjectName' IS NULL THEN 1 ELSE 0 END) as null_projectname,
       SUM(CASE WHEN 'Department' IS NULL THEN 1 ELSE 0 END) as null_department,
       SUM(CASE WHEN 'Region' IS NULL THEN 1 ELSE 0 END)as null_regions,
       SUM(CASE WHEN 'ProjectDate' IS NULL THEN 1 ELSE 0 END) null_hours_projectdate,
       SUM(CASE WHEN 'HoursWorked' IS NULL THEN 1 ELSE 0 END) null_hous_worked,
       SUM(CASE WHEN 'Revenue' IS NULL THEN 1 ELSE 0 END) null_revenue,
       SUM(CASE WHEN 'ProjectManager' IS NULL THEN 1 ELSE 0 END) null_projectmanage,
       SUM(CASE WHEN 'Status' IS NULL THEN 1 ELSE 0 END) null_status_project
FROM wenge_table

---identifyning duplicates values

SELECT DISTINCT ProjectID,ClientID ,COUNT(*) AS total_records from wenge_table
GROUP BY ProjectID,ClientID

HAVING COUNT(*)>1

--OR 

WITH CHECK_DUPLICATES AS (
SELECT ProjectID,ClientID ,
ROW_NUMBER () OVER(ORDER BY ProjectID,ClientID) as row_num
FROM wenge_table

)
SELECT * FROM CHECK_DUPLICATES
WHERE row_num>1

--BINARY VARIATE ANALYSIS

--analysing the single column
--@compare  department with revenue

SELECT Department ,sum(Revenue) as total_revenue,AVG(Revenue) as avg_revenue
FROM wenge_table
GROUP BY Department

--compare region with revenue

SELECT Region ,SUM(Revenue) as total_revenue
FROM wenge_table
WHERE Region !='not eixt'
GROUP BY Region

--BINARY VARIATE ANALYSIS
--determine revenue distributed of departent in each region

SELECT Department,Region,sum(Revenue) as total_revenue,
      AVG(Revenue)as avg_revenue 
FROM wenge_table

GROUP BY Region,Department

----determine revenue distributed of region in each departmnet
SELECT Department,Region,sum(Revenue) as total_revenue,
      AVG(Revenue)as avg_revenue 
FROM wenge_table

GROUP BY Department,Region

--multivariate analysis

SELECT ProjectID,Department,Region ,SUM(Revenue) as total_revenue
FROM wenge_table
GROUP BY ProjectID,Department,Region 

--CTE
--generate serial number 
WITH SERIAL_NUMBER AS (
SELECT 2 AS NUMBER 
UNION ALL

SELECT NUMBER+2
FROM SERIAL_NUMBER
WHERE NUMBER<20

)

SELECT * FROM SERIAL_NUMBER

--generate serial date

WITH SERIAL_DATE AS (
SELECT CAST('2026-10-10' AS DATE) AS DATE
    
    UNION ALL
SELECT DATEADD(day,1,DATE) 
FROM SERIAL_DATE
WHERE  DATE<CAST('2026-10-30' AS DATE)
)
SELECT * FROM SERIAL_DATE

---HIERACHICAL ANALYSIS OF COMPANY

SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM CTE_TABLE_SERIAL

WITH SERIAL_ORGAN AS (
SELECT mfanyakaziID,cheo_mfanyakazi,mshahara,bossID , 1 AS LEVEL
FROM CTE_TABLE_SERIAL

     UNION ALL
SELECT CT.mfanyakaziID,CT.cheo_mfanyakazi,CT.mshahara,CT.bossID ,SE.LEVEL+1
FROM CTE_TABLE_SERIAL CT
 INNER JOIN SERIAL_ORGAN SE ON CT.bossID=SE.mfanyakaziID

)
SELECT * FROM SERIAL_ORGAN




