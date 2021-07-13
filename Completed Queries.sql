#Keeper Queries

# Cleaning up the tables and data
# Remove the Seasons table and everything in it
TRUNCATE TABLE seasons;
DROP TABLE seasons;

#finds how many and which rows have the � in them
SELECT driver_id, first_name, surname FROM drivers WHERE surname LIKE '%�%';
SELECT COUNT(*) FROM drivers WHERE surname LIKE '%�%';

# Removes the � character from the surname of drivers
call sp_clean_special_chars_drivers('�');
call sp_clean_special_chars_drivers('̦');

# Checking to see unique/distinct values
SELECT DISTINCT * FROM current_status ORDER BY current_status;

# Remove the URL column from drivers, circuits, constructors, and races
ALTER TABLE drivers DROP COLUMN url;
ALTER TABLE circuits DROP COLUMN url;
ALTER TABLE constructors DROP COLUMN url;
ALTER TABLE races DROP COLUMN url;

# Updates to NULL were string, but needed to be NULL values
CALL sp_change_string_to_null;

# Remove the extra column from the Constructors and constructor_standings tables 
ALTER TABLE constructors DROP COLUMN extra;
ALTER TABLE constructor_standings DROP COLUMN extra;

# For the fastest_lap_time, replace -1 values with NULL (used a stored Procedure)
call sp_replace_negative_1_with_null;

#Remove the alt column since all values are NULL 
ALTER TABLE circuits DROP COLUMN alt;

SHOW Tables in Formula1;
SHOW COLUMNS FROM Results;
DESCRIBE INFORMATION_SCHEMA.CHARACTER_SETS;
SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES;
SHOW TABLES IN INFORMATION_SCHEMA;
SELECT * FROM INFORMATION_SCHEMA.PARTITIONS;
SELECT * FROM INFORMATION_SCHEMA.ENGINES;
SELECT * FROM INFORMATION_SCHEMA.STATISTICS;
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS;
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE;
SELECT * FROM INFORMATION_SCHEMA.USER_PRIVILEGES;
SELECT * FROM INFORMATION_SCHEMA.SCHEMA_PRIVILEGES;
SELECT * FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES;
SELECT * FROM INFORMATION_SCHEMA.FILES;
SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST;
SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;
SHOW COLUMNS FROM results;
SHOW COUNT(*) WARNINGS;
SHOW COUNT(*) ERRORS;
SHOW TABLE STATUS;
SHOW CREATE TABLE results;
SHOW WARNINGS;
SHOW ERRORS;
SHOW ENGINES;

SELECT 
	first_name, 
	surname,
    dob,
    RANK() OVER (ORDER BY dob desc) AS DOB_Ranking
FROM drivers;

USE Formula1;
SELECT 
	first_name, 
	surname,
    dob,
    DENSE_RANK() OVER (ORDER BY dob desc) AS DOB_Ranking
FROM drivers;

SELECT VERSION();
SELECT SYSDATE();
SELECT SESSION_USER();
SELECT now();
SELECT hour(now());
SELECT day(now());
SELECT DAYOFWEEK(NOW());
SELECT DAYOFMONTH(NOW());
SELECT dayofyear(now());
SELECT quarter(now());
SELECT MONTHNAME(NOW());
SELECT datediff(NOW(),LAST_DAY(NOW()));
SELECT ADDDATE(NOW(),INTERVAL 2 MONTH);
SELECT CURDATE();
SELECT ADDTIME(NOW(),'10:00:00');
SELECT ORD('Brian');
SELECT CONNECTION_ID();
SELECT CURRENT_USER();
SELECT SCHEMA();
SELECT AVG(char_length(surname)) FROM drivers;
ANALYZE TABLE circuits;
EXPLAIN SELECT * FROM drivers LIMIT 25;
CHECK TABLE circuits;
SELECT USER();

SELECT sf_circuit_country('UK') AS "# of Circuits in this Country";
SHOW FUNCTION STATUS;

SELECT d.first_name AS 'First Name', d.surname AS 'Last Name', ra.race_year AS 'Race Year', ra.race_name AS 'Race Name', sec_to_time(avg(re.milliseconds)/1000) AS 'Ave. Lap time (in ms)'
FROM ((results as re left join drivers as d ON re.driver_id=d.driver_id) left join races as ra ON re.race_id=ra.race_id)
GROUP BY re.race_id, re.driver_id;

UPDATE qualifying SET q3=NULL WHERE q3=-1.0000 AND race_id=18;
UPDATE qualifying SET q2=NULL WHERE q2=-1.0000 AND race_id=18;
UPDATE qualifying SET q2=NULL WHERE q2=-1.0000 AND race_id<100;
UPDATE qualifying SET q3=NULL WHERE q3=-1.0000 AND race_id>100;

SELECT COUNT(*) FROM qualifying WHERE q1!=-1;
SELECT COUNT(*) FROM qualifying;
SELECT ((SELECT COUNT(*) FROM qualifying)-(SELECT COUNT(*) FROM qualifying WHERE q1!=-1)) AS "# of racers not to complete 1st lap of qualifying";

SELECT race_year AS 'Season', MIN(race_date) AS 'First Race', MAX(race_date) AS 'Last Race', DATEDIFF(MAX(race_date), MIN(race_date)) AS 'Season Length' FROM races GROUP BY race_year;

SELECT ra.race_year, d.first_name, d.surname, re.points 
FROM (results as re left join drivers as d ON re.driver_id=d.driver_id) left join races as ra on re.race_id=ra.race_id
WHERE (ra.race_year BETWEEN 2005 AND 2010) 
GROUP BY ra.race_year, d.first_name, d.surname, re.points
ORDER BY ra.race_year, re.points desc;

SELECT
    ra.race_name AS 'Race Name',
    ra.race_date AS 'Date of Race',
    c.location AS 'Location',
    c.country AS 'Country',
    cast(ms2time(MIN(re.milliseconds)/1000) AS TIME) AS 'Minimum',
    cast(ms2time(round(AVG(re.milliseconds)/1000,5)) AS TIME) AS 'Mean',
    cast(ms2time(round(MAX(re.milliseconds)/1000,5)) AS TIME) AS 'Maximum',
    round(STD(re.milliseconds)/1000,3) AS 'Std Dev',
    CAST(ms2time(round(VARIANCE(re.milliseconds)/1000,5)) AS TIME) AS 'Variance'
FROM
    (results re left join races as ra ON re.race_id=ra.race_id) left join circuits as c ON ra.circuit_id=c.circuit_id
WHERE 
	(re.milliseconds IS NOT NULL) AND (ra.race_year BETWEEN 1980 AND 2020)
GROUP BY
	ra.race_name, ra.race_date, c.country, c.location
ORDER BY 
	STDDEV_SAMP(re.milliseconds);

#Changing the dob from varchar to date data type
ALTER TABLE drivers ADD COLUMN updated_dob date NULL;

# To get around having to temporarily change a setting, I split each update into 2.
# I have since learned to update the SQL_SAFE_UPDATES both before and after 
#updates, instead of what I did right here
UPDATE drivers
SET 
    updated_dob = DATE_FORMAT(STR_TO_DATE(dob, '%Y-%m-%d'), '%Y-%m-%d')
WHERE
    (LOCATE('-',dob, 5)) AND (driver_id>=500);
    
UPDATE drivers
SET 
    updated_dob = DATE_FORMAT(STR_TO_DATE(dob, '%Y-%m-%d'), '%Y-%m-%d')
WHERE
    (LOCATE('-',dob, 5)) AND (driver_id<=500);

UPDATE drivers
SET 
    updated_dob = DATE_FORMAT(STR_TO_DATE(dob, '%d/%m/%Y'), '%Y-%m-%d')
WHERE
    (LOCATE('/',dob, 3)) AND (driver_id>=500);
    
UPDATE drivers
SET 
    updated_dob = DATE_FORMAT(STR_TO_DATE(dob, '%d/%m/%Y'), '%Y-%m-%d')
WHERE
    (LOCATE('/',dob, 3)) AND (driver_id<=500);

ALTER TABLE drivers DROP COLUMN dob;
ALTER TABLE drivers RENAME COLUMN updated_dob TO dob;

# run the -1 to NULL on qualifying.q1 and qualifying.q2
CREATE VIEW null_qual AS (SELECT * FROM qualifying WHERE q2=-1);
SET SQL_SAFE_UPDATES = 0;
UPDATE null_qual SET q2=null;
SET SQL_SAFE_UPDATES = 1;

CREATE VIEW null_qual_q3 AS (SELECT * FROM qualifying WHERE q3=-1);
SET SQL_SAFE_UPDATES = 0;
UPDATE null_qual_q3 SET q3=null;
SET SQL_SAFE_UPDATES = 1;

SELECT 
	DISTINCT d.first_name AS First_Name,
    d.surname AS Last_Name,
    ra.race_year AS Race_Year,
    (SUM(re.points) OVER (PARTITION BY d.surname, First_Name)) AS Total_Points
FROM (results AS re LEFT JOIN races AS ra ON re.race_id=ra.race_id) LEFT JOIN drivers AS d ON re.driver_id=d.driver_id
WHERE Race_Year = 2010
ORDER BY Total_Points desc;

SELECT 
	DISTINCT hour(race_time) as 'Hour of day',
    COUNT(*) OVER (PARTITION BY hour(race_time)) as 'Count'
FROM races;

SELECT 
	first_name AS First_Name, 
    surname AS Last_Name, 
    dob AS 'Date of Birth',
	(TIMESTAMPDIFF(YEAR, dob, current_date)) AS Age
FROM 
	drivers
WHERE 
	(TIMESTAMPDIFF(YEAR, dob, current_date)) BETWEEN 30 AND 40
ORDER BY 
	Age desc;

SELECT 
	circuit_name AS 'Circuit',
    location AS Location, 
    country AS Country
FROM 
	circuits
WHERE
	circuit_name LIKE 'C%';

# Calling the race results stored procedure    
call sp_race_results(2010,10);

# Calculate the number of days for each season using date calculation functions
SELECT 
	race_year AS 'Season', 
    DATEDIFF(max(race_date), min(race_date)) AS 'Season Length (in days)'
FROM 
	races 
GROUP BY 
	race_year 
ORDER BY 
	race_year desc;

# At a time when there were more columns, I used the following to check if two columns were identical information
SELECT SUM(STRCMP(lap_time, sf_ms_to_time(milliseconds))) FROM laptimes;

# modification to convert laptimes.milliseconds from milliseconds to seconds
ALTER TABLE laptimes ADD COLUMN lap_time double;
ALTER TABLE laptimes MODIFY COLUMN milliseconds double;
SET SQL_SAFE_UPDATES=0;
UPDATE laptimes SET lap_time=(milliseconds/1000);
SET SQL_SAFE_UPDATES=1;
ALTER TABLE laptimes DROP COLUMN milliseconds;

# results.milliseconds to complete_race_time
ALTER TABLE results ADD COLUMN complete_race_time double;
SET SQL_SAFE_UPDATES=0;
UPDATE results SET complete_race_time=(milliseconds/1000);
SET SQL_SAFE_UPDATES=1;
ALTER TABLE results DROP COLUMN milliseconds;

SELECT 
	race_year AS 'Season',
    IFNULL(sec_to_time(avg(q1)), '-') AS 'Lap 1 Qualifying Time',
    IFNULL(sec_to_time(avg(q2)), '-') AS 'Lap 2 Qualifying Time',
    IFNULL(sec_to_time(avg(q3)), '-') AS 'Lap 3 Qualifying Time'
FROM
	qualifying as q INNER JOIN races as r
    ON q.race_id=r.race_id
GROUP BY
	race_year
ORDER BY
    -race_year asc;

# Now, query for average, min, max, count, and stddev grouped by year
SELECT 
	IFNULL(r.race_year, 'Total') AS 'Season',
    COUNT(DISTINCT r.race_round) AS 'Season Length',
    COUNT(q.q1) AS 'Total Qualification Laps',
    round(COUNT(q1)/COUNT(DISTINCT r.race_round),0) AS 'Qual Laps/Race',
    TIME_FORMAT(IFNULL(sec_to_time(avg(q.q1)), '-'), '%i:%s.%f') AS 'Average',
    TIME_FORMAT(IFNULL(sec_to_time(min(q.q1)), '-'), '%i:%s.%f') AS 'Minimum',
    TIME_FORMAT(IFNULL(sec_to_time(max(q.q1)), '-'), '%i:%s.%f') AS 'Maximum',
    TIME_FORMAT(IFNULL(sec_to_time(stddev(q.q1)), '-'), '%s.%f') AS 'Std Dev (in Sec)'
FROM
	qualifying as q INNER JOIN races as r
    ON q.race_id=r.race_id
GROUP BY
	r.race_year WITH ROLLUP
ORDER BY
    r.race_year desc;

# Using stored functions
SELECT 
	IFNULL(r.race_year, 'Total') AS 'Season',
    COUNT(DISTINCT r.race_round) AS 'Season Length',
    COUNT(q.q1) AS 'Total Qual Laps',
    ROUND(COUNT(q1)/COUNT(DISTINCT r.race_round),0) AS 'Qual Laps/Race',
    format_null_ms(avg(q.q1)) AS 'Average',
    format_null_ms(min(q.q1)) AS 'Minimum',
    format_null_ms(max(q.q1)) AS 'Maximum',
    format(stddev(q.q1), 3) AS 'Std Dev (s)'
FROM
	qualifying as q INNER JOIN races as r
    ON q.race_id=r.race_id
GROUP BY
	r.race_year
ORDER BY
    r.race_year desc;

# How many days until Thanksgiving
SELECT days_until_thanksgiving(current_date());

