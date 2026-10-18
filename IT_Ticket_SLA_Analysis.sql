-- =====================================================
-- IT Ticket & SLA Performance Analysis (MySQL)
-- Dataset: Technical Support Dataset (Kaggle, Suvradeep)
-- 2330 tickets | Author: Pranjal
-- =====================================================

-- STEP 1: Database
CREATE DATABASE IF NOT EXISTS it_ticket_sla;
USE it_ticket_sla;

-- STEP 2: Raw (staging) table - everything as text so import never fails
CREATE TABLE IF NOT EXISTS tickets_raw (
    status VARCHAR(30),
    ticket_id INT,
    priority VARCHAR(20),
    source VARCHAR(30),
    topic VARCHAR(100),
    agent_group VARCHAR(50),
    agent_name VARCHAR(100),
    created_time VARCHAR(30),
    expected_sla_resolve VARCHAR(30),
    expected_sla_first_response VARCHAR(30),
    first_response_time VARCHAR(30),
    sla_first_response VARCHAR(30),
    resolution_time VARCHAR(30),
    sla_resolution VARCHAR(30),
    close_time VARCHAR(30),
    agent_interactions VARCHAR(10),
    survey_results VARCHAR(10),
    product_group VARCHAR(100),
    support_level VARCHAR(20),
    country VARCHAR(100),
    latitude VARCHAR(30),
    longitude VARCHAR(30)
);

-- STEP 3: Load CSV (change the path to your own file; use / not \)
-- SET GLOBAL local_infile = 1;
-- TRUNCATE TABLE tickets_raw;
-- LOAD DATA LOCAL INFILE 'C:/path/to/Technical Support Dataset.csv'
-- INTO TABLE tickets_raw
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (status, ticket_id, priority, source, topic, agent_group, agent_name,
--  created_time, expected_sla_resolve, expected_sla_first_response,
--  first_response_time, sla_first_response, resolution_time, sla_resolution,
--  close_time, agent_interactions, survey_results, product_group, support_level,
--  country, latitude, longitude);

-- STEP 4: Clean table (text -> DATETIME, blanks -> NULL, drop lat/long)
SET SESSION sql_mode = '';
DROP TABLE IF EXISTS tickets_clean;

CREATE TABLE tickets_clean AS
SELECT
  ticket_id,
  TRIM(status) AS status,
  TRIM(priority) AS priority,
  TRIM(source) AS source,
  TRIM(topic) AS topic,
  TRIM(agent_group) AS agent_group,
  TRIM(agent_name) AS agent_name,
  COALESCE(STR_TO_DATE(TRIM(created_time),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(created_time),'%Y-%m-%d %H:%i:%s')) AS created_time,
  COALESCE(STR_TO_DATE(TRIM(expected_sla_resolve),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(expected_sla_resolve),'%Y-%m-%d %H:%i:%s')) AS expected_sla_resolve,
  COALESCE(STR_TO_DATE(TRIM(expected_sla_first_response),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(expected_sla_first_response),'%Y-%m-%d %H:%i:%s')) AS expected_sla_first_response,
  COALESCE(STR_TO_DATE(TRIM(first_response_time),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(first_response_time),'%Y-%m-%d %H:%i:%s')) AS first_response_time,
  NULLIF(TRIM(sla_first_response),'') AS sla_first_response,
  COALESCE(STR_TO_DATE(TRIM(resolution_time),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(resolution_time),'%Y-%m-%d %H:%i:%s')) AS resolution_time,
  NULLIF(TRIM(sla_resolution),'') AS sla_resolution,
  COALESCE(STR_TO_DATE(TRIM(close_time),'%Y-%m-%d %H:%i:%s.%f'), STR_TO_DATE(TRIM(close_time),'%Y-%m-%d %H:%i:%s')) AS close_time,
  CAST(NULLIF(TRIM(agent_interactions),'') AS DECIMAL(5,0)) AS agent_interactions,
  CAST(NULLIF(TRIM(survey_results),'') AS DECIMAL(2,0)) AS survey_results,
  TRIM(product_group) AS product_group,
  TRIM(support_level) AS support_level,
  TRIM(country) AS country
FROM tickets_raw;

-- Validation: expect total = 2330, created_null = 0
SELECT
  COUNT(*) AS total,
  SUM(created_time IS NULL) AS created_null,
  SUM(first_response_time IS NULL) AS first_resp_null,
  SUM(resolution_time IS NULL) AS resolution_null
FROM tickets_clean;

-- =====================================================
-- ANALYSIS
-- =====================================================

-- Q1: Total tickets
SELECT COUNT(*) AS total_tickets
FROM tickets_clean;

-- Q2: SLA met vs breached (1547 met, 783 violated)
SELECT sla_resolution, COUNT(*) AS tickets
FROM tickets_clean
GROUP BY sla_resolution;

-- Q3: Overall SLA compliance % (66.39%)
SELECT
  COUNT(*) AS total,
  SUM(sla_resolution = 'Within SLA') AS met,
  ROUND(SUM(sla_resolution = 'Within SLA') * 100 / COUNT(*), 2) AS compliance_pct
FROM tickets_clean;

-- Q4: Priority-wise breach %
SELECT
  priority,
  COUNT(*) AS total,
  SUM(sla_resolution = 'SLA Violated') AS breached,
  ROUND(SUM(sla_resolution = 'SLA Violated') * 100 / COUNT(*), 2) AS breach_pct
FROM tickets_clean
GROUP BY priority;

-- Q5: Topic-wise tickets and breach %
SELECT
  topic,
  COUNT(*) AS total,
  SUM(sla_resolution = 'SLA Violated') AS breached,
  ROUND(SUM(sla_resolution = 'SLA Violated') * 100 / COUNT(*), 2) AS breach_pct
FROM tickets_clean
GROUP BY topic
ORDER BY total DESC;

-- Q6: Agent-wise breach % (agents with at least 30 tickets)
SELECT
  agent_name,
  COUNT(*) AS total,
  SUM(sla_resolution = 'SLA Violated') AS breached,
  ROUND(SUM(sla_resolution = 'SLA Violated') * 100 / COUNT(*), 2) AS breach_pct
FROM tickets_clean
GROUP BY agent_name
HAVING COUNT(*) >= 30
ORDER BY breach_pct DESC
LIMIT 10;
