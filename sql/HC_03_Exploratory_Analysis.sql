-- =====================================================
-- 1. PATIENT DEMOGRAPHICS
-- =====================================================

-- TOTAL PATIENTS
SELECT COUNT(*) AS total_patients
FROM `synthea_analytics.patients_clean`;

-- AVERAGE AGE
SELECT
ROUND(AVG(age), 2) AS average_age
FROM `synthea_analytics.patients_clean`;

-- AGE DISTRIBUTION
SELECT
  CASE
    WHEN age < 18 THEN '0-17'
    WHEN age BETWEEN 18 AND 34 THEN '18-34'
    WHEN age BETWEEN 35 AND 49 THEN '35-49'
    WHEN age BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM `synthea_analytics.patients_clean`
GROUP BY age_group
ORDER BY age_group;

-- GENDER DISTRIBUTION
SELECT
  gender,
  COUNT(*) AS patient_count
FROM `synthea_analytics.patients_clean`
GROUP BY gender
ORDER BY patient_count DESC;

-- HEALTHCARE EXPENSES BY AGE GROUP
SELECT
  CASE
    WHEN age < 18 THEN '0-17'
    WHEN age BETWEEN 18 AND 34 THEN '18-34'
    WHEN age BETWEEN 35 AND 49 THEN '35-49'
    WHEN age BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  ROUND(AVG(healthcare_expenses), 2) AS avg_expenses,
  ROUND(AVG(healthcare_coverage), 2) AS avg_coverage
FROM `synthea_analytics.patients_clean`
GROUP BY age_group
ORDER BY age_group;


-- =====================================================
-- 2. HEALTHCARE UTILIZATION
-- =====================================================

-- ENCOUNTER TYPES
SELECT
  encounter_class,
  COUNT(*) AS encounter_count
FROM `synthea_analytics.encounters_clean`
GROUP BY encounter_class
ORDER BY encounter_count DESC;

-- AVERAGE LENGTH OF STAY
SELECT
  ROUND(AVG(length_of_stay_days), 2) AS avg_length_of_stay
FROM `synthea_analytics.encounters_clean`;

-- ENCOUNTERS PER PATIENT
SELECT
  ROUND(AVG(encounter_count), 2) AS avg_encounters_per_patient
FROM (
  SELECT
    patient_id,
    COUNT(*) AS encounter_count
  FROM `synthea_analytics.encounters_clean`
  GROUP BY patient_id
);

-- HEALTHCARE UTILIZATION BY AGE GROUP
SELECT
  CASE
    WHEN p.age < 18 THEN '0-17'
    WHEN p.age BETWEEN 18 AND 34 THEN '18-34'
    WHEN p.age BETWEEN 35 AND 49 THEN '35-49'
    WHEN p.age BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  COUNT(e.encounter_id) AS encounter_count,
  ROUND(
    COUNT(e.encounter_id) * 1.0 /
    COUNT(DISTINCT p.patient_id),
    2
  ) AS avg_encounters_per_patient
FROM `synthea_analytics.patients_clean` p
LEFT JOIN `synthea_analytics.encounters_clean` e
  ON p.patient_id = e.patient_id
GROUP BY age_group
ORDER BY age_group;


-- =====================================================
-- 3. CLINICAL ANALYSIS
-- =====================================================

-- TOP 10 CONDITIONS
SELECT
  condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean`
GROUP BY condition_description
ORDER BY condition_count DESC
LIMIT 10;

-- TOP CONDITIONS CAUSING ENCOUNTERS
SELECT
  condition_description,
  COUNT(DISTINCT patient_id) AS affected_patients
FROM `synthea_analytics.conditions_clean`
GROUP BY condition_description
ORDER BY affected_patients DESC
LIMIT 20;

-- TOP CONDITIONS IN 65+ PATIENTS
SELECT
  c.condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean` c
INNER JOIN `synthea_analytics.patients_clean` p
  ON c.patient_id = p.patient_id
WHERE p.age >= 65
GROUP BY c.condition_description
ORDER BY condition_count DESC
LIMIT 20;

-- TOP DISEASES ONLY
SELECT
  condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean`
WHERE condition_description LIKE '%(disorder)%'
GROUP BY condition_description
ORDER BY condition_count DESC
LIMIT 20;

-- TOP DISEASES IN 65+ PATIENTS
SELECT
  c.condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean` c
INNER JOIN `synthea_analytics.patients_clean` p
  ON c.patient_id = p.patient_id
WHERE p.age >= 65
  AND c.condition_description LIKE '%(disorder)%'
GROUP BY c.condition_description
ORDER BY condition_count DESC
LIMIT 20;

-- TOP 10 MEDICATIONS
SELECT
  medication_description,
  COUNT(*) AS medication_count
FROM `synthea_analytics.medications_clean`
GROUP BY medication_description
ORDER BY medication_count DESC
LIMIT 10;

-- TOP 10 PROCEDURES
SELECT
  procedure_description,
  COUNT(*) AS procedure_count
FROM `synthea_analytics.procedures_clean`
GROUP BY procedure_description
ORDER BY procedure_count DESC
LIMIT 10;


-- =====================================================
-- 4. PATIENT OUTCOMES
-- =====================================================

-- MORTALITY RATE
SELECT
  ROUND(
    100 * COUNTIF(deathdate IS NOT NULL) / COUNT(*),
    2
  ) AS mortality_rate_pct
FROM `synthea_analytics.patients_clean`;

-- MORTALITY BY AGE GROUP
SELECT
  CASE
    WHEN age < 18 THEN '0-17'
    WHEN age BETWEEN 18 AND 34 THEN '18-34'
    WHEN age BETWEEN 35 AND 49 THEN '35-49'
    WHEN age BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS patients,
  COUNTIF(deathdate IS NOT NULL) AS deaths
FROM `synthea_analytics.patients_clean`
GROUP BY age_group
ORDER BY age_group;

-- MORTALITY BY GENDER
SELECT
  gender,
  COUNT(*) AS patients,
  COUNTIF(deathdate IS NOT NULL) AS deaths,
  ROUND(
    100 * COUNTIF(deathdate IS NOT NULL) / COUNT(*),
    2
  ) AS mortality_rate_pct
FROM `synthea_analytics.patients_clean`
GROUP BY gender;

-- CONDITIONS AMONG DECEASED PATIENTS
SELECT
  c.condition_description,
  COUNT(DISTINCT c.patient_id) AS affected_patients
FROM `synthea_analytics.conditions_clean` c
INNER JOIN `synthea_analytics.patients_clean` p
  ON c.patient_id = p.patient_id
WHERE p.deathdate IS NOT NULL
GROUP BY c.condition_description
ORDER BY affected_patients DESC
LIMIT 20;