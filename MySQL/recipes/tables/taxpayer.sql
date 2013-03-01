# taxpayer.sql

# NULL value comparison illustration

DROP TABLE IF EXISTS taxpayer;
#@ _CREATE_TABLE_
CREATE TABLE taxpayer
(
  name  CHAR(20),
  id    CHAR(20)
);
#@ _CREATE_TABLE_

INSERT INTO taxpayer (name,id) VALUES ('bernina','198-48');
INSERT INTO taxpayer (name,id) VALUES ('bertha',NULL);
INSERT INTO taxpayer (name,id) VALUES ('ben',NULL);
INSERT INTO taxpayer (name,id) VALUES ('bill','475-83');

SELECT * FROM taxpayer;

# These both should fail, because = and != do not work with NULL values

SELECT * FROM taxpayer WHERE id = NULL;
SELECT * FROM taxpayer WHERE id != NULL;

# These both should succeed

SELECT * FROM taxpayer WHERE id IS NULL;
SELECT * FROM taxpayer WHERE id IS NOT NULL;


