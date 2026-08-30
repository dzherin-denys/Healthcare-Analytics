-- =====================================================
-- 1. POPULATION KPIS
-- =====================================================

-- TOTAL PATIENTS
SELECT
COUNT(*) AS total_patients
FROM `synthea_analytics.patients_clean`;

-- AVERAGE AGE
SELECT
ROUND(AVG(age), 2) AS average_age
FROM `synthea_analytics.patients_clean`;

-- MORTALITY RATE
SELECT
  ROUND(
    100 * COUNTIF(deathdate IS NOT NULL) / COUNT(*),
    2
  ) AS mortality_rate_pct
FROM `synthea_analytics.patients_clean`;


-- =====================================================
-- 2. HEALTHCARE UTILIZATION KPIS
-- =====================================================

-- TOTAL ENCOUNTERS
SELECT
COUNT(*) AS total_encounters
FROM `synthea_analytics.encounters_clean`;

-- AVERAGE ENCOUNTERS PER ACTIVE PATIENT
SELECT
  ROUND(
    COUNT(*) / COUNT(DISTINCT patient_id),
    2
  ) AS avg_encounters_per_active_patient
FROM `synthea_analytics.encounters_clean`;

-- PATIENTS WITH ENCOUNTERS
SELECT
  COUNT(DISTINCT patient_id) AS patients_with_encounters
FROM `synthea_analytics.encounters_clean`;

-- AVERAGE LENGTH OF STAY
SELECT
  ROUND(
    AVG(length_of_stay_days),
    2
  ) AS avg_length_of_stay
FROM `synthea_analytics.encounters_clean`;

-- MOST COMMON ENCOUNTER TYPE
SELECT
  encounter_class,
  COUNT(*) AS encounter_count
FROM `synthea_analytics.encounters_clean`
GROUP BY encounter_class
ORDER BY encounter_count DESC
LIMIT 1;


-- =====================================================
-- 3. FINANCIAL KPIS
-- =====================================================

-- AVERAGE HEALTHCARE EXPENSES
SELECT
  ROUND(
    AVG(healthcare_expenses),
    2
  ) AS avg_healthcare_expenses
FROM `synthea_analytics.patients_clean`;

-- AVERAGE HEALTHCARE COVERAGE
SELECT
  ROUND(
    AVG(healthcare_coverage),
    2
  ) AS avg_healthcare_coverage
FROM `synthea_analytics.patients_clean`;


-- =====================================================
-- 4. CLINICAL KPIS
-- =====================================================

-- MOST COMMON DISEASE
SELECT
  condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean`
WHERE condition_description LIKE '%(disorder)%'
GROUP BY condition_description
ORDER BY condition_count DESC
LIMIT 1;

-- MOST COMMON MEDICATION
SELECT
  medication_description,
  COUNT(*) AS medication_count
FROM `synthea_analytics.medications_clean`
GROUP BY medication_description
ORDER BY medication_count DESC
LIMIT 1;

-- MOST COMMON PROCEDURE
SELECT
  procedure_description,
  COUNT(*) AS procedure_count
FROM `synthea_analytics.procedures_clean`
GROUP BY procedure_description
ORDER BY procedure_count DESC
LIMIT 1;

-- =====================================================
-- DATASET OBSERVATION
-- =====================================================

-- During data validation, an unusual relationship was identified between the patient registry and encounter activity. The dataset contains 11,550 registered patients, while encounter records are available for 847 patients only. Additional validation confirmed valid patient identifiers, correct key relationships, successful joins, and no referential integrity issues. Healthcare utilization KPIs are therefore calculated based on patients with encounter history and interpreted within the context of the source dataset.