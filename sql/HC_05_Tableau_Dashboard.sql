-- =====================================================
-- DASHBOARD 2
-- =====================================================

-- ENCOUNTER TYPE DISTRIBUTION
SELECT
  encounter_class,
  COUNT(*) AS encounter_count
FROM `synthea_analytics.encounters_clean`
GROUP BY encounter_class
ORDER BY encounter_count DESC;

-- LENGTH OF STAY GROUP DISTRIBUTION
-- Removed from final Healthcare Utilization dashboard.
-- The distribution was highly skewed because the vast
-- majority of encounters had a length of stay of 0 days.
-- The resulting visualization provided limited analytical
-- value and was replaced by more informative utilization
-- metrics.
SELECT
  CASE
    WHEN length_of_stay_days = 0 THEN '0 Days'
    WHEN length_of_stay_days BETWEEN 1 AND 3 THEN '1-3 Days'
    WHEN length_of_stay_days BETWEEN 4 AND 7 THEN '4-7 Days'
    ELSE '8+ Days'
  END AS los_group,
  COUNT(*) AS encounter_count
FROM `synthea_analytics.encounters_clean`
GROUP BY los_group
ORDER BY encounter_count DESC;

-- AVERAGE LOS BY ENCOUNTER TYPE
SELECT
  encounter_class,
  ROUND(AVG(length_of_stay_days), 2) AS avg_length_of_stay
FROM `synthea_analytics.encounters_clean`
GROUP BY encounter_class
ORDER BY avg_length_of_stay DESC;

-- AVERAGE COST BY ENCOUNTER TYPE
SELECT
  encounter_class,
  ROUND(AVG(total_claim_cost), 2) AS avg_claim_cost
FROM `synthea_analytics.encounters_clean`
GROUP BY encounter_class
ORDER BY avg_claim_cost DESC;


-- =====================================================
-- DASHBOARD 3
-- =====================================================

-- TOP CONDITIONS
SELECT
  condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean`
GROUP BY condition_description
ORDER BY condition_count DESC
LIMIT 15;

-- TOP MEDICATIONS
SELECT
  medication_description,
  COUNT(*) AS medication_count
FROM `synthea_analytics.medications_clean`
GROUP BY medication_description
ORDER BY medication_count DESC
LIMIT 15;

-- TOP PROCEDURES
SELECT
  procedure_description,
  COUNT(*) AS procedure_count
FROM `synthea_analytics.procedures_clean`
GROUP BY procedure_description
ORDER BY procedure_count DESC
LIMIT 15;

-- CONDITIONS BY AGE GROUP
-- Removed from the final Tableau dashboard.
-- The visualization was developed and evaluated during the analysis phase.
-- However, the resulting chart provided limited analytical value and reduced
-- dashboard readability due to the large number of categories displayed.
-- The final Clinical Analysis dashboard focuses on Top Clinical Findings,
-- Top Medications, and Top Procedures for clearer business insights.

SELECT
  CASE
    WHEN p.age < 18 THEN '0-17'
    WHEN p.age BETWEEN 18 AND 34 THEN '18-34'
    WHEN p.age BETWEEN 35 AND 49 THEN '35-49'
    WHEN p.age BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  c.condition_description,
  COUNT(*) AS condition_count
FROM `synthea_analytics.conditions_clean` c
JOIN `synthea_analytics.patients_clean` p
  ON c.patient_id = p.patient_id
GROUP BY
  age_group,
  c.condition_description
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY age_group
  ORDER BY COUNT(*) DESC
) <= 5
ORDER BY
  age_group,
  condition_count DESC;


-- =====================================================
-- DASHBOARD 4
-- =====================================================

-- MORTALITY BY AGE GROUP
-- Removed from final Dashboard 4 implementation.
-- Existing "Mortality by Age Group" worksheet from
-- Dashboard 1 was reused to avoid duplication.

-- MORTALITY BY GENDER
SELECT
  gender,
  ROUND(
    AVG(
      CASE
        WHEN deathdate IS NOT NULL THEN 1
        ELSE 0
      END
    ) * 100,
    2
  ) AS mortality_rate
FROM `synthea_analytics.patients_clean`
GROUP BY gender;

-- MORTALITY BY AGE
SELECT
  age,
  ROUND(
    AVG(
      CASE
        WHEN deathdate IS NOT NULL THEN 1
        ELSE 0
      END
    ) * 100,
    2
  ) AS mortality_rate
FROM `synthea_analytics.patients_clean`
GROUP BY age
ORDER BY age;