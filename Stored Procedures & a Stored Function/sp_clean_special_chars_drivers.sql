CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_clean_special_chars_drivers`(spec_char CHAR)
BEGIN
SET SQL_SAFE_UPDATES=0;
UPDATE drivers SET surname=replace(surname, spec_char, '');
SET SQL_SAFE_UPDATES=1;
END