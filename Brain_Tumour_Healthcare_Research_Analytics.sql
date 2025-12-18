
-- Create database --
CREATE DATABASE IF NOT EXISTS project_schema;

-- Use the database --
USE project_schema;

-- Check current database --
SELECT DATABASE();

-- Show tables in the database --
SHOW TABLES FROM project_schema;

-- Describe Table --
select * from genomics;
select * from imaging;
select * from patients;
select * from treatments;
select * from trials;

-- Patients (PK: patient_id)
-- Imaging (FK: patient_id)        → One-to-Many (imaging)
-- Genomics (FK: patient_id)       → One-to-One (Genomics)
-- Treatments (FK: patient_id)     → One-to-Many (Treatments)
-- Clinical_Trials (FK: patient_id)→ One-to-Many (Trials)



-- Section A – Window Functions with Healthcare Insights

-- (Questions 1) Rank patients by survival per tumor type
-- Display patient_id, tumor_type, survival_months, and RANK()

SELECT * FROM 
(SELECT p.patient_id, p.tumor_type, t.survival_months,
RANK() OVER ( PARTITION BY p.tumor_type ORDER BY t.survival_months DESC ) AS survival_rank
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
) ranked_patients;

-- (Questions 2) Top 3 patients per tumor type (DENSE_RANK)

SELECT *
FROM ( SELECT p.patient_id, p.tumor_type, t.survival_months,
DENSE_RANK() OVER (PARTITION BY p.tumor_type ORDER BY t.survival_months DESC) AS survival_rank
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
) ranked_patients
WHERE survival_rank <= 3;


-- (Questions 3) Sequential number per hospital using ROW_NUMBER()

SELECT patient_id, hospital, diagnosis_date,
ROW_NUMBER() OVER (PARTITION BY hospital ORDER BY diagnosis_date) AS seq_no
FROM patients
hospital_sequence;

-- (Questions 4) Divide patients into quartiles using radiomic score (NTILE)

SELECT patient_id, radiomic_score,
NTILE(4) OVER (ORDER BY radiomic_score) AS radiomic_quartile
FROM imaging
radiomic_quartiles;

-- (Questions 5) Average Survival per Tumor Type Using Window Function using AVG() OVER (PARTITION BY ...) 

SELECT p.patient_id, p.tumor_type, t.survival_months,
AVG(t.survival_months) OVER (PARTITION BY p.tumor_type) AS avg_survival
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id;


-- Section B – GROUP BY vs PARTITION BY (Clear Contrast)


-- (Question 6A) Using GROUP BY – Average tumor volume per tumor type
SELECT p.tumor_type,
AVG(i.tumor_volume_cc) AS avg_tumor_volume
FROM patients p
JOIN imaging i
ON p.patient_id = i.patient_id
GROUP BY p.tumor_type;

-- (Question 6B) Using AVG() OVER (PARTITION BY tumor_type) – Patient-level rows
SELECT p.patient_id, p.tumor_type, i.tumor_volume_cc,
AVG(i.tumor_volume_cc) OVER (PARTITION BY p.tumor_type) AS avg_tumor_volume
FROM patients p
JOIN imaging i
ON p.patient_id = i.patient_id;

-- (Question 7) Display tumor type, patient survival, and maximum survival within the same tumor type

SELECT p.patient_id, p.tumor_type, t.survival_months,
MAX(t.survival_months) OVER (PARTITION BY p.tumor_type) AS max_survival_in_tumor
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id;

-- (Questions 8) Hospital-wise patient count with overall patient total using GROUP BY and COUNT() OVER() 

SELECT hospital, patients_per_hospital,
SUM(patients_per_hospital) OVER () AS total_patients_overall
FROM (SELECT hospital, COUNT(patient_id) AS patients_per_hospital
FROM patients
GROUP BY hospital
) hospital_counts;


-- Section C – JOINs + Window Functions (Core Analytical Skills)

-- (Questions 9) Join patients, treatments, and genomics tables..
-- Patient Ranking by Immune Biomarker Score within Tumor Types --

SELECT p.patient_id, p.tumor_type, g.immune_biomarker_score,
RANK() OVER (PARTITION BY p.tumor_type ORDER BY g.immune_biomarker_score DESC) AS biomarker_rank
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
JOIN genomics g
ON p.patient_id = g.patient_id;

-- (Question 10) Join patients and imaging tables
-- Radiomic Score Deviation from Tumor-wise Average --

SELECT p.patient_id, p.tumor_type, i.radiomic_score,
AVG(i.radiomic_score) OVER (PARTITION BY p.tumor_type) AS avg_radiomic_score, 
i.radiomic_score -
AVG(i.radiomic_score) OVER (PARTITION BY p.tumor_type) AS radiomic_deviation
FROM patients p
JOIN imaging i
ON p.patient_id = i.patient_id;


-- (Questions 11) Using patients + treatments
-- Latest Treatment per Patient Using ROW_NUMBER() --

SELECT patient_id, treatment_type, start_date
FROM (SELECT p.patient_id, t.treatment_type, t.start_date,
ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY t.start_date DESC) AS rn
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
) latest_treatment
WHERE rn = 1;

-- (Question 12) Join patients + clinical_trials
-- Trial Phase Priority Ranking within Tumor Types --

SELECT p.patient_id, p.tumor_type, c.trial_phase,
RANK() OVER (PARTITION BY p.tumor_type ORDER BY c.trial_phase DESC) AS trial_priority_rank
FROM patients p
JOIN trials c
ON p.patient_id = c.patient_id;


-- Section D – Time-based & Research-oriented Analysis --
-- (Question 13) 
SELECT p.patient_id,p.tumor_type,p.diagnosis_date,t.survival_months,
SUM(t.survival_months) OVER (PARTITION BY p.tumor_type ORDER BY p.diagnosis_date) AS cumulative_survival
FROM patients p 
JOIN treatments t 
ON p.patient_id=t.patient_id;


-- (Question 14) Running total of enrolled clinical-trial patients per hospital over time --
-- Tables & columns used (patients: patient_id, hospital) (trials: enroll_date)

SELECT p.hospital, c.enroll_date,
COUNT(*) OVER (PARTITION BY p.hospital ORDER BY c.enroll_date) AS running_trial_total
FROM patients p
JOIN trials c
ON p.patient_id = c.patient_id;

-- (Question 15) Compare average survival of trial-enrolled vs non-enrolled patients per tumor type
-- Tables used (patients) (treatments) (trials (LEFT JOIN to include non-enrolled patients))

SELECT tumor_type, trial_status, avg_survival
FROM (
    -- Enrolled patients (real data)
SELECT p.tumor_type, 'Enrolled' AS trial_status, AVG(t.survival_months) AS avg_survival
FROM patients p
JOIN treatments t ON p.patient_id = t.patient_id
JOIN trials c ON p.patient_id = c.patient_id
GROUP BY p.tumor_type

UNION ALL
-- Not Enrolled patients (forced, shown as 0)
SELECT DISTINCT p.tumor_type, 'Not Enrolled' AS trial_status, 0 AS avg_survival
FROM patients p
) final_result
ORDER BY tumor_type, trial_status;

-- Section E – Views & Reusable Research Insights --
-- (Question 16) Glioblastoma (GBM) Patients with Advanced Therapy and Biomarker Details (VIEW Creation)--
-- Tables used (patients), (treatments), (genomics) --

CREATE OR REPLACE VIEW gbm_advanced_therapy AS
SELECT
p.patient_id,
p.tumor_type,
t.treatment_type,
t.survival_months,
g.immune_biomarker_score,
g.MGMT_methylation,
g.EGFR_status,
g.IDH_status
FROM patients p
JOIN treatments t 
ON p.patient_id = t.patient_id
JOIN genomics g 
ON p.patient_id = g.patient_id
WHERE p.tumor_type = 'Glioblastoma (GBM)'
AND t.treatment_type IN ('Immunotherapy', 'Targeted Therapy');

-- How to verify the view --
SELECT * FROM gbm_advanced_therapy;


-- (Question 17) Replace the VIEW to include radiomic_score & tumor volume --
-- Additional table (imaging → radiomic_score, tumor_volume_cc) --

CREATE OR REPLACE VIEW gbm_advanced_therapy AS
SELECT
p.patient_id,
p.tumor_type,
t.treatment_type,
t.survival_months,
g.immune_biomarker_score,
g.MGMT_methylation,
g.EGFR_status,
g.IDH_status,
i.radiomic_score,
i.tumor_volume_cc
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
JOIN genomics g
ON p.patient_id = g.patient_id
JOIN imaging i
ON p.patient_id = i.patient_id
WHERE p.tumor_type = 'Glioblastoma (GBM)'
AND t.treatment_type IN ('Immunotherapy', 'Targeted Therapy');

-- Check updated view --
SELECT * FROM gbm_advanced_therapy;


-- (Question 18) Drop the VIEW after analysis --

DROP VIEW gbm_advanced_therapy;

-- show drop view --

SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- (Section F) – Advanced Ranking & Decision Support --
-- (Question 19) Identify the best performing treatment per tumor type (based on average survival) using RANK()
-- Tables used (patients) (treatments)

SELECT tumor_type, treatment_type, avg_survival, treatment_rank
FROM (SELECT p.tumor_type, t.treatment_type, AVG(t.survival_months) AS avg_survival,
RANK() OVER (PARTITION BY p.tumor_type ORDER BY AVG(t.survival_months) DESC) AS treatment_rank
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
GROUP BY p.tumor_type, t.treatment_type
) ranked_treatments
WHERE treatment_rank = 1;

-- (Question 20) Classify patients into High / Medium / Low survival risk groups -- using NTILE(3) based on survival_months --
-- Tables used (patients), (treatments),(genomics (joined as required)) --

SELECT rc.patient_id, rc.tumor_type, rc.survival_months, g.immune_biomarker_score,
CASE
WHEN rc.risk_group = 1 THEN 'Low Risk'
WHEN rc.risk_group = 2 THEN 'Medium Risk'
WHEN rc.risk_group = 3 THEN 'High Risk'
END AS survival_risk

FROM (SELECT p.patient_id, p.tumor_type, t.survival_months,
NTILE(3) OVER (ORDER BY t.survival_months DESC) AS risk_group
FROM patients p
JOIN treatments t
ON p.patient_id = t.patient_id
) rc
JOIN genomics g
ON rc.patient_id = g.patient_id;



-- DONE ALL QUERY QUESTIONS-------- 000000000 -----------------------------



















