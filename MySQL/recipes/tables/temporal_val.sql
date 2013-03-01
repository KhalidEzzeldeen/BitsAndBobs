# temporal_val.sql

# Table that contains each kind of temporal value, to illustrate
# date and time sorting

DROP TABLE IF EXISTS temporal_val;
#@ _CREATE_TABLE_
CREATE TABLE temporal_val
(
  d   DATE,
  dt  DATETIME,
  t   TIME,
  ts  TIMESTAMP
);
#@ _CREATE_TABLE_

INSERT INTO temporal_val (d, dt, t, ts)
  VALUES
    ('1970-01-01','1884-01-01 12:00:00','13:00:00','1980-01-01 02:00:00'),
    ('1999-01-01','1860-01-01 12:00:00','19:00:00','2021-01-01 03:00:00'),
    ('1981-01-01','1871-01-01 12:00:00','03:00:00','1975-01-01 04:00:00'),
    ('1964-01-01','1899-01-01 12:00:00','01:00:00','1985-01-01 05:00:00')
;

SELECT * FROM temporal_val;
