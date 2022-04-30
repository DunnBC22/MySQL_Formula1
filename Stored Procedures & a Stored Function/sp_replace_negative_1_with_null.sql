CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_replace_negative_1_with_null`()
BEGIN
SET SQL_SAFE_UPDATES = 0;
UPDATE results 
SET fastest_lap_time = NULL
WHERE fastest_lap_time = -1;
SET SQL_SAFE_UPDATES = 1;
END