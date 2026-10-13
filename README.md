# 📊 SQL Data Analysis Project: Performance & Revenue Analysis

## 📌 Overview
This repository contains a comprehensive SQL data analysis script conducted on project management and performance data. The project explores project metrics, evaluates departmental and regional revenue contributions, performs time-series trends, and analyzes retention rates using SQL window functions and Common Table Expressions (CTEs).

---

## 🛠️ Tech Stack & SQL Concepts Applied
* **Database Management System:** Microsoft SQL Server (T-SQL)
* **SQL Concepts Applied:**
  * **Data Exploration & Quality Check:** Identifying missing values (`CASE WHEN`), counting distinct records, duplicate detection.
  * **Aggregations & Grouping:** `SUM()`, `AVG()`, `COUNT()`, `GROUP BY`, `HAVING`.
  * **Window Functions:** `SUM() OVER()`, `AVG() OVER()`, `LAG() OVER()`, `DENSE_RANK() OVER()`.
  * **Cohort & Retention Analysis:** `DATETRUNC()`, `DATEDIFF()`, Conditional Aggregations.
  * **Business Metrics:** Month-over-Month (MoM) revenue growth, variance analysis, percentage contribution.

---

## 🔍 Key Findings & Insights
1. **Regional Performance:** The **South Region** recorded the highest overall revenue compared to other regions.
2. **Revenue Fluctuations:** Revenue peaks significantly around **April and October**, whereas dips are observed in **December and February**.
3. **Project Retention Rate:** Cohort analysis revealed a 0% retention rate for recurring project IDs, indicating that projects are currently one-off events rather than multi-month repeating contracts.

---

## 📁 Repository Structure
