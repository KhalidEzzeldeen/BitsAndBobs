# seqtest.sql

# A table that contains nothing more than an AUTO_INCREMENT column,
# for use in testing sequence-generation operations

DROP TABLE IF EXISTS seqtest;
#@ _CREATE_TABLE_
CREATE TABLE seqtest
(
  seq INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
);
#@ _CREATE_TABLE_

SELECT * FROM seqtest;
