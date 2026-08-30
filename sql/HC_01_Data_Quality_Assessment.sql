-- =====================================================
-- HEALTHCARE ANALYTICS PROJECT
-- DATA QUALITY ASSESSMENT
-- =====================================================


-- =====================================================
-- 1. ROW COUNTS
-- =====================================================

SELECT 'patients' AS table_name, COUNT(*) AS row_count
FROM `synthea_raw.patients`

UNION ALL

SELECT 'encounters', COUNT(*)
FROM `synthea_raw.encounters`

UNION ALL

SELECT 'conditions', COUNT(*)
FROM `synthea_raw.conditions`

UNION ALL

SELECT 'medications', COUNT(*)
FROM `synthea_raw.medications`

UNION ALL

SELECT 'procedures', COUNT(*)
FROM `synthea_raw.procedures`

UNION ALL

SELECT 'careplans', COUNT(*)
FROM `synthea_raw.careplans`

UNION ALL

SELECT 'providers', COUNT(*)
FROM `synthea_raw.providers`

UNION ALL

SELECT 'organizations', COUNT(*)
FROM `synthea_raw.organizations`;


-- =====================================================
-- 2. COMPLETENESS
-- =====================================================

-- Missing Birth Dates
SELECT COUNT(*) AS missing_birthdates
FROM `synthea_raw.patients`
WHERE BIRTHDATE IS NULL;

-- Missing Encounter IDs
SELECT COUNT(*) AS missing_encounter_ids
FROM `synthea_raw.encounters`
WHERE Id IS NULL;

-- Missing Patient IDs in Encounters
SELECT COUNT(*) AS missing_patient_ids
FROM `synthea_raw.encounters`
WHERE PATIENT IS NULL;

-- Missing Patient IDs in Conditions
SELECT COUNT(*) AS missing_patient_ids
FROM `synthea_raw.conditions`
WHERE PATIENT IS NULL;

-- Missing Patient IDs in Medications
SELECT COUNT(*) AS missing_patient_ids
FROM `synthea_raw.medications`
WHERE PATIENT IS NULL;

-- Missing Patient IDs in Procedures
SELECT COUNT(*) AS missing_patient_ids
FROM `synthea_raw.procedures`
WHERE PATIENT IS NULL;


-- =====================================================
-- 3. UNIQUENESS
-- =====================================================

-- Duplicate Patient IDs
SELECT
  Id,
  COUNT(*) AS duplicate_count
FROM `synthea_raw.patients`
GROUP BY Id
HAVING COUNT(*) > 1;

-- Duplicate Encounter IDs
SELECT
  Id,
  COUNT(*) AS duplicate_count
FROM `synthea_raw.encounters`
GROUP BY Id
HAVING COUNT(*) > 1;

-- Duplicate Careplan IDs
SELECT
  Id,
  COUNT(*) AS duplicate_count
FROM `synthea_raw.careplans`
GROUP BY Id
HAVING COUNT(*) > 1;


-- =====================================================
-- 4. REFERENTIAL INTEGRITY
-- =====================================================

-- Encounters -> Patients
SELECT COUNT(*) AS missing_patient_records
FROM `synthea_raw.encounters` e
LEFT JOIN `synthea_raw.patients` p
ON e.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Conditions -> Patients
SELECT COUNT(*) AS missing_patient_records
FROM `synthea_raw.conditions` c
LEFT JOIN `synthea_raw.patients` p
ON c.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Medications -> Patients
SELECT COUNT(*) AS missing_patient_records
FROM `synthea_raw.medications` m
LEFT JOIN `synthea_raw.patients` p
ON m.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Procedures -> Patients
SELECT COUNT(*) AS missing_patient_records
FROM `synthea_raw.procedures` pr
LEFT JOIN `synthea_raw.patients` p
ON pr.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Careplans -> Patients
SELECT COUNT(*) AS missing_patient_records
FROM `synthea_raw.careplans` cp
LEFT JOIN `synthea_raw.patients` p
ON cp.PATIENT = p.Id
WHERE p.Id IS NULL;


-- =====================================================
-- 5. VALIDITY
-- =====================================================

-- Invald Birth Dates
SELECT COUNT(*) AS invalid_birthdates
FROM `synthea_raw.patients`
WHERE BIRTHDATE > CURRENT_DATE();

-- Age Validation
SELECT
  MIN(DATE_DIFF(CURRENT_DATE(), BIRTHDATE, YEAR)) AS min_age,
  MAX(DATE_DIFF(CURRENT_DATE(), BIRTHDATE, YEAR)) AS max_age
FROM `synthea_raw.patients`;

-- Encounter Date Validation
SELECT COUNT(*) AS invalid_encounters
FROM `synthea_raw.encounters`
WHERE STOP < START;

-- Condition Date Validation
SELECT COUNT(*) AS invalid_conditions
FROM `synthea_raw.conditions`
WHERE STOP < START;

-- Medication Date Validation
-- Result: 62 records with STOP date earlier than START date
SELECT COUNT(*) AS invalid_medications
FROM `synthea_raw.medications`
WHERE STOP < START;

-- Procedure Date Validation
SELECT COUNT(*) AS invalid_procedures
FROM `synthea_raw.procedures`
WHERE STOP < START;

-- Careplan Date Validation
SELECT COUNT(*) AS invalid_careplans
FROM `synthea_raw.careplans`
WHERE STOP < START;