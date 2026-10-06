
USE energy_analysis;

SELECT country,year,electricity_generation
FROM energy_data
WHERE country='greece'
ORDER BY year ASC;

SELECT country,year,electricity_generation
FROM energy_data
WHERE year='2024' and entity_type='country'
ORDER BY electricity_generation desc
limit 10;

SELECT country, year, nuclear_electricity,(nuclear_electricity/SUM(nuclear_electricity) OVER(PARTITION BY year))*100 as percentage_of_nuclear_power
FROM energy_data
WHERE entity_type = 'continent' and year=2024
ORDER BY country, year;

SELECT country, year, electricity_demand_per_capita
FROM energy_data
WHERE entity_type = 'other' and year>2019;

SELECT country, year, electricity_demand_per_capita
FROM energy_data
WHERE country='europe' and year>2019;


SELECT country, year, solar_electricity
FROM energy_data
WHERE country='europe' and year>2019;

SELECT country, year, solar_electricity,
ROUND(
    (solar_electricity -
    MAX(CASE WHEN year = 2020 THEN solar_electricity END)
    OVER(PARTITION BY country))
    /
    MAX(CASE WHEN year = 2020 THEN solar_electricity END)
    OVER(PARTITION BY country) * 100, 2
) AS solar_growth_percentage
FROM energy_data
WHERE country = 'europe' AND year >= 2020
ORDER BY year;


SELECT country, year, wind_electricity,
ROUND(
    (wind_electricity -
    MAX(CASE WHEN year = 2020 THEN wind_electricity END)
    OVER(PARTITION BY country))
    /
    MAX(CASE WHEN year = 2020 THEN wind_electricity END)
    OVER(PARTITION BY country) * 100, 2
) AS wind_growth_percentage
FROM energy_data
WHERE country = 'europe' AND year >= 2020
ORDER BY year;

SELECT country, year,
       electricity_generation,
       fossil_electricity,
       ROUND(
           fossil_electricity / electricity_generation * 100, 2
       ) AS fossil_percentage
FROM energy_data
WHERE year = 2024
AND entity_type = 'country'
AND electricity_generation > 0
AND fossil_electricity IS NOT NULL
and population>5000000
ORDER BY fossil_percentage DESC
LIMIT 10;

SELECT country,

MAX(CASE WHEN year = 2020 THEN fossil_electricity END) AS fossil_2020,
MAX(CASE WHEN year = 2024 THEN fossil_electricity END) AS fossil_2024,

ROUND(
    (
        MAX(CASE WHEN year = 2024 THEN fossil_electricity END) -
        MAX(CASE WHEN year = 2020 THEN fossil_electricity END)
    ) /
    NULLIF(MAX(CASE WHEN year = 2020 THEN fossil_electricity END), 0) * 100, 2
) AS fossil_change_percentage
FROM energy_data
WHERE entity_type = 'country'
AND year IN (2020, 2024)
GROUP BY country
HAVING fossil_2020 > 0
AND fossil_2024 IS NOT NULL
ORDER BY fossil_change_percentage ASC
LIMIT 10;















