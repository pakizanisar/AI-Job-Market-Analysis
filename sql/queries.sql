USE ai_job_market_db;

-- 	Q1: Salary Drivers
-- =======================================
-- 1A: Average Salary by Experience Level
-- =======================================
SELECT 
	experience_level, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY experience_level
ORDER BY avg_salary;

-- =====================================
-- 1B: Average Salary by Company Size
-- =====================================
SELECT 
	company_size, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY company_size
ORDER BY avg_salary;

-- =======================================
-- 1C: Average Salary by Education Level
-- =======================================
SELECT 
	education_level, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY education_level
ORDER BY avg_salary;

-- =======================================
-- 1D: Average Salary by Total Skills
-- =======================================
SELECT 
	total_skills, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY total_skills
ORDER BY avg_salary;

-- =======================================
-- 1E: Average Salary by Remote Type
-- =======================================
SELECT 
	remote_type, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY remote_type
ORDER BY avg_salary;

-- ===============================================
-- Comparative Salary Analysis Across Key Drivers
-- ===============================================
SELECT drivers,
		driver_type,
		ROUND(
        AVG(salary), 2
        ) AS avg_salary 
FROM(
	SELECT salary, "Experience_level" AS drivers, experience_level AS driver_type
    FROM ai_job_market
    UNION ALL 
    SELECT salary, "Company size" AS drivers, company_size AS driver_type
    FROM ai_job_market
    UNION ALL
    SELECT salary, "Education level" AS drivers, education_level AS driver_type
    FROM ai_job_market
    UNION ALL
    SELECT salary, "Total Skills" AS drivers, total_skills AS driver_type
    FROM ai_job_market
    UNION ALL
    SELECT salary, "Remote Type" AS drivers, remote_type AS driver_type
    FROM ai_job_market
    )t
GROUP BY drivers, driver_type;



-- Q2: Experience vs Salary Progression
-- ==========================================
-- 2A: Average Salary By Years of Experience
-- ==========================================
SELECT 
    years_experience, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY years_experience
ORDER BY years_experience; 

-- ==========================================
-- 2B: Average Salary By Experience Category
-- =========================================
SELECT 
    experience_category, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY experience_category
ORDER BY avg_salary;



-- Q3: Experience Level Consistency
-- =======================================
-- 3A: Experience Level Alignment
-- =======================================
SELECT 
	experience_level,
    experience_category,
    COUNT(*) AS total_jobs
FROM ai_job_market
GROUP BY experience_level, experience_category
ORDER BY experience_level;

-- ==================================
-- 3B: Match vs Mismatch Analysis
-- ==================================
SELECT 
	CASE
		WHEN experience_level = experience_category THEN 'Match'
        ELSE 'Mismatch'
	END AS alignment_status,
    ROUND(
    COUNT(*) * 100/ (
    SELECT COUNT(*)
    FROM ai_job_market
    ), 
    2) AS percentage
FROM ai_job_market
GROUP BY alignment_status;



-- =======================================
-- Q4: Salary Premium by Technical Skills
-- =======================================
SELECT
	skills,
    ROUND(
    AVG(CASE WHEN skill_value = 1 THEN salary END), 
    2) AS salary_with_skill,
    ROUND(
    AVG(CASE WHEN skill_value = 0 THEN salary END), 2)
    AS salary_without_skill,
    ROUND(
    AVG(CASE WHEN skill_value = 1 Then salary END) -
    AVG(CASE WHEN skill_value = 0 Then salary END)
    ,2) AS premium
FROM (
	SELECT salary, "Python" AS skills, skills_python AS skill_value
    FROM ai_job_market
    UNION ALL
    SELECT salary, "SQL" AS skills, skills_sql AS skill_value 
    FROM ai_job_market
    UNION ALL
    SELECT salary, "ML" AS skills, skills_ml AS skill_value
    FROM ai_job_market
    UNION ALL
    SELECT salary, "Deep Learning" AS skills, skills_deep_learning AS skill_value
    FROM ai_job_market
    UNION ALL
    SELECT salary, "Cloud" AS skills, skills_cloud AS skill_value
    FROM ai_job_market)t
GROUP BY skills
ORDER BY premium;



-- ============================================================
-- Q5: Salary Progression and Hiring Demand by Skill Intensity 
-- ============================================================

SELECT 
	total_skills, 
	ROUND(AVG(salary), 2) AS avg_salary, 
    COUNT(*) AS total_jobs
FROM ai_job_market
GROUP BY total_skills
ORDER BY total_skills;



-- ================================================
-- Q6: Salary and Hiring Demand by Industry Type
-- ================================================
SELECT 
	company_industry, 
	ROUND(AVG(salary), 2) AS avg_salary, 
    COUNT(*) AS total_jobs
FROM ai_job_market
GROUP BY company_industry
ORDER BY avg_salary;



-- ==========================================
-- Q7: Salary and Hiring Demand by Country
-- ==========================================
SELECT 
	country, 
	ROUND(AVG(salary), 2) AS avg_salary, 
    COUNT(*) AS total_jobs
FROM ai_job_market
GROUP BY country
ORDER BY avg_salary;



-- ===========================================================
-- Q8: Average Salary by Education (Experience is Controlled)
-- ===========================================================
SELECT 
	education_level,
    ROUND(
		AVG(CASE WHEN experience_level = "Entry" THEN salary End),
        2) AS entry_level,
	ROUND(
		AVG(CASE WHEN experience_level = "Mid" THEN salary End),
        2) AS mid_level, 
	ROUND(
		AVG(CASE WHEN experience_level = "Senior" THEN salary End),
        2) AS senior_level
FROM ai_job_market
GROUP BY education_level
ORDER BY education_level;



-- =================================================
-- Q9: Salary and Hiring Demand by Hiring Urgency
-- =================================================
SELECT 
	hiring_urgency, 
    COUNT(*) AS total_jobs,
	ROUND(AVG(salary), 2) AS avg_salary
FROM ai_job_market
GROUP BY hiring_urgency
ORDER BY avg_salary;



-- Q10: Hiring Urgency vs Work Mode
-- =======================================
-- 10A: COUNT ANALYSIS
-- =======================================
SELECT 
	remote_type,
    SUM(CASE 
		WHEN hiring_urgency = "Low" 
		THEN 1 ELSE 0 
		END) AS "low_urgency",
	SUM(CASE 
		WHEN hiring_urgency = "Medium" 
		THEN 1 	ELSE 0
		END) AS "medium_urgency",
	SUM(CASE 
		WHEN hiring_urgency = "High" 
        THEN 1 ELSE 0
        END) AS "high_urgency"
FROM ai_job_market
GROUP BY remote_type;

-- =======================================
-- Q10B: Percentage Analysis
-- =======================================
SELECT 
	remote_type,
    ROUND(
		SUM(CASE 
        WHEN hiring_urgency = "Low" 
        THEN 1 ELSE 0
        END) * 100.0 / COUNT(*),
        2) AS "low_urgency_pct",
	ROUND(
		SUM(CASE 
        WHEN hiring_urgency = "Medium" 
        THEN 1 ELSE 0
        END) * 100.0 / COUNT(*),
        2)AS "medium_urgency_pct",
	ROUND(
    SUM(CASE 
    WHEN hiring_urgency = "High" 
    THEN 1 ELSE 0 
    END) * 100/COUNT(*), 
    2) AS "high_urgency(%)"
FROM ai_job_market
GROUP BY remote_type;
	


    
	
