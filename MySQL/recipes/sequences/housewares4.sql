# housewares4.sql

SELECT category, serial, country,
CONCAT(category,LPAD(serial,5,'0'),country) AS id
FROM housewares4;
