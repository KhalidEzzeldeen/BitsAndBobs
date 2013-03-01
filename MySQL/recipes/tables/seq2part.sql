# seq2part.sql

DROP TABLE IF EXISTS seq2part;
#@ _CREATE_TABLE_
CREATE TABLE seq2part
(
  prefix  CHAR(1) NOT NULL,
  seq     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (prefix, seq)
);
#@ _CREATE_TABLE_

INSERT INTO seq2part (prefix) VALUES('A'),('A'),('B'),('B'),('C'),('C');

SELECT prefix, seq,
  CONCAT(prefix,LPAD(seq,3,'0'))
FROM seq2part;
