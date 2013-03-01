# houseware_id.sql - define a stored function that returns a houseware
# item identifier, given category, serial number, and country values
# housewares4.sql

DROP FUNCTION IF EXISTS houseware_id;

#@ _CREATE_FUNCTION_
CREATE FUNCTION houseware_id(category VARCHAR(3),
                             serial INT UNSIGNED,
                             country VARCHAR(2))
RETURNS VARCHAR(10) DETERMINISTIC
RETURN CONCAT(category,LPAD(serial,5,'0'),country);
#@ _CREATE_FUNCTION_

#@ _USE_FUNCTION_
SELECT category, serial, country,
houseware_id(category,serial,country) AS id
FROM housewares;
#@ _USE_FUNCTION_
