use hr_analysis;

ALTER TABLE `hr_analysis`.`human resources`
RENAME TO hr;
  
select * from hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

UPDATE hr
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

ALTER TABLE hr
ADD column age INT;

UPDATE hr
SET age = timestampdiff(YEAR,birthdate,curdate());

select min(age),max(age) from hr;

SELECT gender, COUNT(*) AS count 
FROM hr
WHERE termdate IS NULL
GROUP BY gender;

SELECT race , COUNT(*) AS count
from hr
WHERE termdate IS NULL
GROUP BY race;

SELECT 
CASE
WHEN age>=18 AND age<=24 THEN '18-24'
WHEN age>=25 AND age<=34 THEN '25-34'
WHEN age>=35 AND age<=44 THEN '35-44'
WHEN age>=45 AND age<=54 THEN '45-54'
WHEN age>=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group,
    COUNT(*) AS count FROM hr
    WHERE termdate IS NULL
    GROUP BY age_group
    ORDER BY age_group;
    
SELECT location,COUNT(*) AS count
from hr
WHERE termdate IS NULL
GROUP BY location;

SELECT ROUND(AVG(year(termdate) - year(hire_date)),0) AS length_of_emp
from hr
WHERE termdate IS NOT NULL AND termdate <= curdate();

SELECT department,jobtitle,gender,COUNT(*) AS count FROM hr
WHERE termdate IS NOT NULL
GROUP BY department, jobtitle,gender
ORDER BY department, jobtitle,gender;

SELECT department,gender,COUNT(*) AS count FROM hr
WHERE termdate IS NOT NULL
GROUP BY department,gender
ORDER BY department,gender;

SELECT jobtitle, COUNT(*) AS count from hr
WHERE termdate IS NULL
GROUP BY jobtitle;

SELECT location_state, COUNT(*) AS count from hr
WHERE termdate IS NULL
GROUP BY location_state;

SELECT location_city, COUNT(*) AS count from hr
WHERE termdate IS NULL
GROUP BY location_city;

SELECT year, hires, terminations, hires-terminations AS net_change, (terminations/hires)*100 AS change_percent
FROM( SELECT YEAR(hire_date) AS year, COUNT(*) AS hires, 
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 END) AS terminations
FROM hr
GROUP BY YEAR(hire_date)) AS subquery
GROUP BY year
ORDER BY year;

SELECT department, round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate IS NOT NULL AND termdate<= curdate()
GROUP BY department;

select count(*) as total,gender from hr
group by gender;


