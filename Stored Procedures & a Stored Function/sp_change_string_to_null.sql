CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_change_string_to_null`()
BEGIN
SET SQL_SAFE_UPDATES = 0;
UPDATE constructor_results 
SET constructor_status = NULL
WHERE constructor_status = 'NULL';
SET SQL_SAFE_UPDATES = 1;
END