# BRAIN-TUMOUR-HEALTHCARE-RESEARCH-ANALYTICS-USING-ADVANCED-SQL
Comprehensive healthcare analytics project applying advanced SQL techniques to evaluate brain tumour survival outcomes, treatments, imaging, genomics, and clinical trial data.

# 🧠 [ Brain Tumour Healthcare & Research Analytics ]

# 1. Project Title :

Brain Tumour Healthcare & Research Analytics using Advanced SQL.

# 2. Project Description :

This project demonstrates the application of advanced SQL-based data analysis in the healthcare domain, with a focused case study on brain tumour diagnosis, treatment, and clinical research outcomes. The dataset simulates real-world clinical data commonly used in neuro-oncology research and hospital analytics.

The primary aim of this project is to extract meaningful insights from structured medical data using relational database concepts, complex multi-table joins, and advanced window functions. The project is designed to be presented in technical interviews and showcased on GitHub as a complete SQL analytics case study.

# 3. Problem Statement :

Brain tumour management requires integrating multiple heterogeneous data sources such as patient demographics, imaging findings, molecular biomarkers, treatment protocols, survival outcomes, and clinical trial information. Traditional reporting approaches are often inadequate to analyze complex trends across these dimensions.

This project addresses the need for structured healthcare data analysis by using SQL to:

  Analyze survival outcomes across different tumor types.
  Compare treatment effectiveness and patient outcomes.
  Evaluate the impact of imaging and genomic biomarkers.
  Assess clinical trial participation and research-driven outcomes.

# 4. Dataset Overview :

The dataset consists of five interrelated CSV files, each representing a core component of brain tumour healthcare analytics:

Patients: 
  Demographics, tumor type, diagnosis date, hospital, country

Imaging: 
  MRI-based tumor volume, radiomic score, contrast enhancement

Genomics: 
  MGMT methylation, EGFR status, IDH status, TMB, immune biomarker score

Treatments: 
  Treatment type, treatment response, survival duration

Clinical Trials: 
  Trial enrollment status, trial phase, and outcomes

Each table contains approximately 1000 records, enabling realistic, large-scale analytical scenarios.

# 5. Database Schema :

The database follows a relational schema where the Patients table acts as the central entity:

  Patients (Primary Key: patient_id)
  One-to-Many → Imaging
  One-to-One → Genomics
  One-to-Many → Treatments
  One-to-Many → Clinical_Trials

All tables are linked using patient_id as the foreign key, ensuring data integrity and supporting complex JOIN-based analytics. 
The complete database schema and table definitions are available in schema.sql.

# 6. Analytical Objectives :

The project focuses on the following analytical tasks:

  Ranking patients by survival within each tumor type.
  Identifying top-performing treatments using ranking functions.
  Segmenting patients into survival risk groups (High / Medium / Low).
  Comparing survival outcomes of trial-enrolled vs non-enrolled patients.
  Performing hospital-level and population-level performance analysis.
  Conducting time-based and cumulative survival analysis.

# 7. SQL Concepts Demonstrated :

This project demonstrates strong proficiency in advanced SQL concepts, including:

  Multi-table JOINs
  Window functions:
    RANK()
    DENSE_RANK()
    ROW_NUMBER()
    NTILE()
    GROUP BY vs PARTITION BY analysis
    Aggregate functions with ordering
    Creation, replacement, and deletion of SQL VIEWS

# SQL Queries and Analysis :

  Key analytical queries are demonstrated within the project
  The complete SQL query script (Questions 1–20) is available in Brain_Tumour_Healthcare_Research_Analytics.sql

# 📌 SQL Query File:
[Download the SQL Script](Brain_Tumour_Healthcare_Research_Analytics.sql)

# 📌 Complete Query Outputs (Query 1 – Query 20):
[View All Query Output Screenshots](Query-Images/)

# 📌 Dataset Folder:  
[View the Dataset Files](Project_Data_Set/)

# 📌 : Database schema:
[View the Schema Files](schema.sql/)

# Execution and Output :

  All queries were executed using MySQL Workbench
  Query outputs are captured as screenshots and included in the repository for reference.

# Below are the outputs of the executed SQL queries:

# 🔹 Query 1 – Patient Survival Ranking by Tumor Type-->

![Query Output-1](/Query-Images/Q1_rank_patients_by_survival.png)

# 🔹 Query 2 – Top 3 Patients per Tumor Type by Survival-->

![Query Output-2](/Query-Images/Q2_top3_patients_dense_rank.png)

# 🔹 Query 3 – Sequential Patient Numbering per Hospital-->

![Query Output-3](/Query-Images/Q3_row_number_by_hospital.png)

# 🔹 Query 4 – Radiomic Score Quartile Classification-->

![Query Output-4](/Query-Images/Q4_radiomic_score_quartiles.png)

# 🔹 Query 5 – Patient Survival vs Tumor-Type Average Survival-->

![Query Output-3](/Query-Images/Q5_avg_survival_partition.png)


# 8. Key Insights Derived from Analysis :

Applying advanced SQL queries, joins, and window functions on the dataset produces the following insights:

# Tumor-wise Survival Patterns
    * Glioblastoma (GBM) patients exhibit significantly lower survival durations compared to low-grade tumors such as meningioma and pituitary tumors, highlighting the aggressive nature of GBM.

# Treatment Effectiveness
    * Patients receiving immunotherapy or targeted therapies demonstrate improved average survival compared to single-modality treatments such as chemotherapy.

# Biomarker Impact
    * Higher immune biomarker scores and favorable genomic markers (e.g., MGMT methylation and IDH mutation) are associated with better survival outcomes, supporting precision-medicine approaches.

# Imaging-Based Prognosis
    * Lower tumor volume and higher radiomic scores correlate with better clinical outcomes, emphasizing the prognostic value of advanced imaging features.

# Clinical Trial Participation
    * Trial-enrolled patients show measurable differences in survival trends, underscoring the importance of research-driven treatment strategies.

# Hospital-Level Variations
    * Survival outcomes and treatment distributions vary across hospitals, enabling institutional performance and care-pattern analysis.

These insights demonstrate how structured healthcare data can be transformed into meaningful clinical and research intelligence using SQL-based analytics.

# 9. Technology Stack :

1) Database: MySQL
2) Language: SQL (Advanced SQL)
3) Data Format: CSV
4) Tools: MySQL Workbench
5) Version Control: Git & GitHub
6) Domain: Healthcare & Biomedical Analytics

# 10. Project Usage :

This project can be used for:

  SQL and Data Analytics technical interviews.
  Academic evaluation and laboratory assessments.
  Healthcare analytics demonstrations.
  GitHub portfolio presentation.

# 11. How to Run the Project :

  Execute schema.sql to create the database and tables
  Import the CSV files into their respective tables
  Run analytical queries from Brain_Tumour_Healthcare_Research_Analytics.sql
  Review query outputs and screenshots

# 12. Disclaimer :

This dataset is synthetically generated for educational and demonstration purposes only.
It does not contain real patient data and must not be used for clinical decision-making.

This project represents a complete end-to-end SQL analytics workflow, from schema design to advanced analytical querying, and is suitable for both academic evaluation and professional portfolios.

# Author: PUSKAR SARKAR 
# Domain: Healthcare & Biomedical Analytics 
# github: https://github.com/Puskar-2002 

****************************************************************************************************************************************************************************************************************************



