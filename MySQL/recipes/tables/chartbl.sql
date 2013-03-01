# chartbl.sql

# create test table with CHAR columns for demonstrating alter_char.pl

DROP TABLE IF EXISTS chartbl;
#@ _CREATE_TABLE_
CREATE TABLE chartbl
(
  c1  VARCHAR(10),
  c2  VARCHAR(10) BINARY,
  c3  VARCHAR(10) NOT NULL DEFAULT 'abc\'def'
);
#@ _CREATE_TABLE_
