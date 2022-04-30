CREATE DEFINER=`root`@`localhost` FUNCTION `format_null_ms`(ms double) RETURNS time
    READS SQL DATA
    DETERMINISTIC
BEGIN
RETURN TIME_FORMAT(IFNULL(sec_to_time(ms), '-'), '%i:%s.%f');
END