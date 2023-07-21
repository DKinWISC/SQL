/*
COVID-19, also known as coronavirus disease 2019, is a highly contagious illness caused by the severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2).
It was first identified in December 2019 in the city of Wuhan, Hubei province, China. Since then, it has spread rapidly across the globe, leading to a pandemic.
COVID-19 primarily spreads through respiratory droplets when an infected person coughs, sneezes, talks, or breathes heavily.
It can also spread by touching surfaces or objects contaminated with the virus and then touching the face, particularly the eyes, nose, or mouth. 
*/
USE covid19;
SELECT *
FROM covid;

/*
1. It is known that COVID-19 broke out in December 2019 in China.
   When is the first date and which country was it where a firrst human was tested positive for COVID-19?
	1-1 When did it happen?
    1-2 Where did it happen?

2. At the highest level, how was the new positive trends?
	2-1 How was the trend?
    2-2 When did the biggest new positive cases occurred?

3. Which country has the most positive case?
	3-1 Which country has the most positive case in absolute value?
    3-2 Which country has the most positive case percent per population?
    
4. HDI index difference in infection.

*/

SELECT 
	date
    ,continent
    ,location
    ,(SELECT COUNT(*) FROM covid WHERE new_cases = 1 AND date = (SELECT MIN(date) FROM covid WHERE total_cases = 1)AND continent <>'Continent') AS country_count
FROM covid
WHERE
	new_cases = 1
    AND date = (SELECT MIN(date) FROM covid WHERE total_cases = 1)
    AND continent <>'Continent';
    
SELECT 
	continent
    ,COUNT(*) AS country_count
FROM covid
WHERE
	new_cases = 1
    AND date = (SELECT MIN(date) FROM covid WHERE total_cases = 1)
    AND continent <>'Continent'
GROUP BY continent;
/*
Although COVID-19 was initially detected in December 2019, the first confirmed positive cases occurred on January 4th, 2020,
marking the initial recognition of the virus's presence.
Subsequently, these cases were identified in 39 countries across different regions.
Specifically, Africa reported 36 cases, Asia reported 1 case, and Europe reported 2 cases.
*/

SELECT
    formatted_date,
    cumulative_new_cases,
    (cumulative_new_cases - LAG(cumulative_new_cases) OVER (ORDER BY formatted_date)) / cumulative_new_cases * 100 AS percent_change
FROM (
    SELECT 
        DATE_FORMAT(date, '%Y-%m') AS formatted_date,
        SUM(new_cases) AS cumulative_new_cases
    FROM covid
    WHERE location = 'World'
    GROUP BY formatted_date
    ORDER BY formatted_date
) AS subquery;



SELECT
    DATE_FORMAT(covid.date, '%Y-%m') AS formatted_date,
    SUM(covid.new_cases) AS new_case
FROM
    covid
JOIN (
    SELECT
        DATE_FORMAT(date, '%Y-%m') AS formatted_date,
        SUM(new_cases) AS total_cases
    FROM covid
    WHERE location = 'World'
    GROUP BY formatted_date
    ORDER BY total_cases DESC
    LIMIT 10
) AS subquery ON DATE_FORMAT(covid.date, '%Y-%m') = subquery.formatted_date
WHERE covid.location = 'World'
GROUP BY formatted_date
ORDER BY new_case DESC;

/*
According to available data, the COVID-19 pandemic has been characterized by three prominent waves, which significantly contributed to a surge in new positive cases. Notably, the most substantial wave occurred in December 2022, with a staggering count of 91,131,117 new cases.
The second-largest wave transpired in January 2022, recording 90,098,080 new cases.
Lastly, another notable spike in cases took place in July 2022, with a reported 30,347,744 new cases.
Apart from these three distinct outbreak periods, the global  witnessed a relatively consistent average of around 15 million cases per month until March 2023.
This period can be characterized as a phase of sustained, though still significant, transmission of the virus.
*/

CREATE TEMPORARY TABLE countryname
(
	SELECT
		location
        ,continent
        ,MAX(population) as pop
        ,MAX(totaL_deaths)/MAX(population)*100 as total_death
        ,ROUND(MAX(total_cases)/MAX(population)*100,2) as total_case
        ,ROUND(MAX(total_vaccinations)/MAX(population)*100,2) as total_vac
        ,ROUND(MAX(people_vaccinated)/MAX(population)*100,2) as pop_vac
        ,ROUND(MAX(people_fully_vaccinated)/MAX(population)*100,2) as pop_fully
        ,MAX(population_density) as pop_density
        ,MAX(median_age) as med_age
        ,MAX(aged_65_older) as age_65
        ,MAX(gdp_per_capita) as gpd_cap
        ,MAX(life_expectancy) as life_exp
        ,MAX(human_development_index) as HDI
	FROM covid
    WHERE location <>"world" AND continent <>"Continent"
    GROUP BY location
);
DROP TABLE countryname;


SELECT *
FROM countryname
ORDER BY total_case DESC;
















