-- ============================================================
-- VISTAS DE MÉTRICAS DE NEGOCIO — CREDIT RISK DASHBOARD
-- Proyecto: credit-risk-dashboard-123456
-- Dataset: credit_risk
-- Tabla base: loans (32,408 filas)
-- ============================================================

-- ============================================================
-- Vista 1: Tasa de default por grado de crédito
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_grade` AS
SELECT 
  loan_grade,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(SUM(loan_amnt), 2) AS monto_total,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(loan_int_rate), 2) AS tasa_interes_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY loan_grade
ORDER BY loan_grade;

-- ============================================================
-- Vista 2: Tasa de default por rango etario
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_age` AS
SELECT 
  CASE 
    WHEN person_age BETWEEN 20 AND 25 THEN '20-25'
    WHEN person_age BETWEEN 26 AND 30 THEN '26-30'
    WHEN person_age BETWEEN 31 AND 35 THEN '31-35'
    WHEN person_age BETWEEN 36 AND 45 THEN '36-45'
    WHEN person_age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
  END AS rango_edad,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(person_income), 2) AS ingreso_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY rango_edad
ORDER BY 
  CASE rango_edad
    WHEN '20-25' THEN 1
    WHEN '26-30' THEN 2
    WHEN '31-35' THEN 3
    WHEN '36-45' THEN 4
    WHEN '46-55' THEN 5
    ELSE 6
  END;

-- ============================================================
-- Vista 3: Tasa de default por rango de ingreso
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_income` AS
SELECT 
  CASE 
    WHEN person_income < 25000 THEN '< 25K'
    WHEN person_income BETWEEN 25000 AND 49999 THEN '25K - 50K'
    WHEN person_income BETWEEN 50000 AND 74999 THEN '50K - 75K'
    WHEN person_income BETWEEN 75000 AND 99999 THEN '75K - 100K'
    WHEN person_income BETWEEN 100000 AND 149999 THEN '100K - 150K'
    ELSE '150K+'
  END AS rango_ingreso,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(loan_percent_income) * 100, 2) AS pct_ingreso_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY rango_ingreso
ORDER BY 
  CASE rango_ingreso
    WHEN '< 25K' THEN 1
    WHEN '25K - 50K' THEN 2
    WHEN '50K - 75K' THEN 3
    WHEN '75K - 100K' THEN 4
    WHEN '100K - 150K' THEN 5
    ELSE 6
  END;

-- ============================================================
-- Vista 4: Tasa de default por intención del préstamo
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_intent` AS
SELECT 
  loan_intent,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(loan_int_rate), 2) AS tasa_interes_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY loan_intent
ORDER BY tasa_default_pct DESC;

-- ============================================================
-- Vista 5: Tasa de default por tipo de vivienda
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_home` AS
SELECT 
  person_home_ownership,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(person_income), 2) AS ingreso_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY person_home_ownership
ORDER BY tasa_default_pct DESC;

-- ============================================================
-- Vista 6: Tasa de default según default previo
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_default_rate_by_default_hist` AS
SELECT 
  cb_person_default_on_file,
  CASE 
    WHEN cb_person_default_on_file = 'Y' THEN 'Con default previo'
    ELSE 'Sin default previo'
  END AS etiqueta,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(loan_int_rate), 2) AS tasa_interes_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY cb_person_default_on_file, etiqueta
ORDER BY cb_person_default_on_file;

-- ============================================================
-- Vista 7: Distribución de montos de préstamo
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_loan_amount_distribution` AS
SELECT 
  CASE 
    WHEN loan_amnt < 5000 THEN '< 5K'
    WHEN loan_amnt BETWEEN 5000 AND 9999 THEN '5K - 10K'
    WHEN loan_amnt BETWEEN 10000 AND 14999 THEN '10K - 15K'
    WHEN loan_amnt BETWEEN 15000 AND 19999 THEN '15K - 20K'
    WHEN loan_amnt BETWEEN 20000 AND 24999 THEN '20K - 25K'
    ELSE '25K+'
  END AS rango_monto,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(person_income), 2) AS ingreso_promedio,
  ROUND(AVG(loan_percent_income) * 100, 2) AS pct_ingreso_promedio
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY rango_monto
ORDER BY 
  CASE rango_monto
    WHEN '< 5K' THEN 1
    WHEN '5K - 10K' THEN 2
    WHEN '10K - 15K' THEN 3
    WHEN '15K - 20K' THEN 4
    WHEN '20K - 25K' THEN 5
    ELSE 6
  END;

-- ============================================================
-- Vista 8: Segmentos de riesgo consolidados
-- ============================================================
CREATE OR REPLACE VIEW `credit-risk-dashboard-123456.credit_risk.v_risk_segments` AS
SELECT 
  loan_grade,
  CASE 
    WHEN loan_grade IN ('A', 'B', 'C') THEN 'Bajo riesgo'
    ELSE 'Alto riesgo'
  END AS categoria_riesgo,
  COUNT(*) AS n_prestamos,
  ROUND(AVG(loan_status) * 100, 2) AS tasa_default_pct,
  ROUND(AVG(loan_amnt), 2) AS monto_promedio,
  ROUND(AVG(person_income), 2) AS ingreso_promedio,
  ROUND(AVG(loan_int_rate), 2) AS tasa_interes_promedio,
  ROUND(SUM(loan_amnt), 2) AS monto_total_cartera,
  ROUND(SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END), 2) AS monto_en_default
FROM `credit-risk-dashboard-123456.credit_risk.loans`
GROUP BY loan_grade, categoria_riesgo
ORDER BY loan_grade;
