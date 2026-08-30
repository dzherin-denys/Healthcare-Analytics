-- =====================================================
-- PATIENTS CLEAN
-- =====================================================

CREATE OR REPLACE VIEW `synthea_analytics.patients_clean` AS
SELECT
  Id AS patient_id,
  BIRTHDATE AS birthdate,
  DEATHDATE AS deathdate,
  DATE_DIFF(CURRENT_DATE(), BIRTHDATE, YEAR) AS age,
  GENDER AS gender,
  RACE AS race,
  ETHNICITY AS ethnicity,
  CITY AS city,
  COUNTY AS county,
  STATE AS state,
  HEALTHCARE_EXPENSES AS healthcare_expenses,
  HEALTHCARE_COVERAGE AS healthcare_coverage
FROM `synthea_raw.patients`;

-- =====================================================
-- ENCOUNTERS CLEAN
-- =====================================================

CREATE OR REPLACE VIEW `synthea_analytics.encounters_clean` AS
SELECT
  Id AS encounter_id,
  PATIENT AS patient_id,
  ORGANIZATION AS organization_id,
  PROVIDER AS provider_id,
  START AS encounter_start,
  STOP AS encounter_end,
  TIMESTAMP_DIFF(STOP, START, DAY) AS length_of_stay_days,
  ENCOUNTERCLASS AS encounter_class,
  DESCRIPTION AS encounter_description,
  BASE_ENCOUNTER_COST AS base_encounter_cost,
  TOTAL_CLAIM_COST AS total_claim_cost,
  PAYER_COVERAGE AS payer_coverage,
  REASONDESCRIPTION AS reason_description
FROM `synthea_raw.encounters`
WHERE STOP >= START
  OR STOP IS NULL;

-- =====================================================
-- CONDITIONS CLEAN
-- =====================================================

CREATE OR REPLACE VIEW `synthea_analytics.conditions_clean` AS
SELECT
  PATIENT AS patient_id,
  ENCOUNTER AS encounter_id,
  START AS condition_start,
  STOP AS condition_end,
  DESCRIPTION AS condition_description,
FROM `synthea_raw.conditions`
WHERE STOP >= START
  OR STOP IS NULL;

-- =====================================================
-- MEDICATIONS CLEAN
-- =====================================================

CREATE OR REPLACE VIEW `synthea_analytics.medications_clean` AS
SELECT
  PATIENT AS patient_id,
  ENCOUNTER AS encounter_id,
  START AS medication_start,
  STOP AS medication_end,
  CODE AS medication_code,
  DESCRIPTION AS medication_description,
  PAYER AS payer_id,
  TOTALCOST AS total_cost,
  PAYER_COVERAGE AS payer_coverage,
  REASONCODE AS reason_code,
  REASONDESCRIPTION AS reason_description
FROM `synthea_raw.medications`
WHERE STOP >= START
  OR STOP IS NULL;
