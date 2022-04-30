CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_race_results`(r_yr INT, r_round INT)
BEGIN
SELECT 
	RANK() OVER(ORDER BY -r.results_position desc) AS 'Order',
    d.first_name AS 'First Name',
    d.surname AS 'Last Name',
    r.num_number AS '#', 
    full_name(d.first_name, d.surname) AS 'Name', 
    IFNULL(r.results_position, 'DNF') AS 'Result', 
    r.grid AS 'Starting Position',  
    IFNULL(r.fastestLap, '-') AS 'Fast Lap', 
    IFNULL(r.fastest_lap_time, '-') AS 'Fast Lap Time', 
    IFNULL(r.fastest_lap_speed, '-') AS 'Fast Lap Speed',
    r.points as 'Points'
FROM results as r 
	LEFT JOIN drivers as d 
    ON r.driver_id=d.driver_id
WHERE 
	race_id = (SELECT race_id FROM races WHERE race_year=r_yr AND race_round=r_round); 
END