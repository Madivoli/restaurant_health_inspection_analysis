//

Restaurant Health Inspection Analysis 

-- Overall Insights
•	Count the total number of inspections by borough.
•	Calculate the distribution of grades (A, B, C, etc.) across NYC.
•	Identify the most common inspection types (Initial, Re-inspection, Pre-permit).

-- Violation Analysis
•	Find the top 10 most frequent violations (e.g., “Evidence of mice,” “Improper food temperature”).
•	Compare critical vs. non-critical violations.
•	See which boroughs or neighborhoods have the highest rate of critical violations.


//





---
---

1. The Total Number of Inspections by Boro

SELECT boro, COUNT(*) as inspection_count
FROM inspections
GROUP BY boro
ORDER BY inspection_count DESC;


---
2. Distribution of Grades in NYC

SELECT 
    grade, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM inspections
WHERE grade IN ('A', 'B', 'C', 'N', 'Z', 'P')
GROUP BY grade
ORDER BY count DESC;


---
3.	Most Common Inspection Types 

SELECT 
    inspection_type, 
    COUNT(*) AS frequency
FROM inspections
WHERE inspection_type IS NOT NULL
GROUP BY inspection_type
ORDER BY frequency DESC
LIMIT 10;



---
---
1. The top 10 most frequent violations 

SELECT 
    violation_description, 
    COUNT(*) AS violation_count
FROM inspections
WHERE violation_description IS NOT NULL
GROUP BY violation_description
ORDER BY violation_count DESC
LIMIT 10;

---
2. Grades by cuisine type 

SELECT 
    cuisine_description,
    COUNT(CASE WHEN grade = 'A' THEN 1 END) AS count_A,
    COUNT(CASE WHEN grade = 'B' THEN 1 END) AS count_B,
    COUNT(CASE WHEN grade = 'C' THEN 1 END) AS count_C,
    COUNT(*) AS total_graded_inspections
FROM inspections
WHERE grade IN ('A', 'B', 'C')
GROUP BY cuisine_description
ORDER BY total_graded_inspections DESC
LIMIT 10;

---
3. Top 5 cuisines with the lowest average scores

SELECT 
    cuisine_description, 
    ROUND(AVG(score), 2) AS average_score,
    COUNT(*) AS total_inspections
FROM inspections
WHERE score IS NOT NULL
  AND cuisine_description NOT IN ('Not Listed/Not Applicable', 'Not Applicable') 
  AND cuisine_description IS NOT NULL
GROUP BY cuisine_description
HAVING total_inspections > 10
ORDER BY average_score ASC
LIMIT 5;

---
4. Top 5 cuisines with the highest average scores

SELECT 
    cuisine_description, 
    ROUND(AVG(score), 2) AS average_score,
    COUNT(*) AS total_inspections
FROM inspections
WHERE score IS NOT NULL
  AND cuisine_description NOT IN ('Not Listed/Not Applicable', 'Not Applicable') 
  AND cuisine_description IS NOT NULL
GROUP BY cuisine_description
HAVING total_inspections > 10
ORDER BY average_score DESC 
LIMIT 5;


---
4. Cuisines with the highest proportion of “Critical” violations

SELECT 
    cuisine_description,
    COUNT(*) AS critical_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_total_city_criticals
FROM inspections
WHERE critical_flag = 'Critical'
GROUP BY cuisine_description
ORDER BY critical_count DESC
LIMIT 3;