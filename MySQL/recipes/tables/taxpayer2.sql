# taxpayer2.sql

# taxpayer table, defined with NOT NULL columns

DROP TABLE IF EXISTS taxpayer;
#@ _CREATE_TABLE_
CREATE TABLE taxpayer
(
  name  CHAR(20) NOT NULL,
  id    CHAR(20) NOT NULL
);
#@ _CREATE_TABLE_
