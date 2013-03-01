# driver_log.sql

# Table for logging truck driver miles-driven-per-day records

DROP TABLE IF EXISTS driver_log;
#@ _CREATE_TABLE_
CREATE TABLE driver_log
(
  rec_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name      VARCHAR(20) NOT NULL,
  trav_date DATE NOT NULL,
  miles     INT NOT NULL,
  PRIMARY KEY (rec_id)
);
#@ _CREATE_TABLE_

INSERT INTO driver_log (name,trav_date,miles)
  VALUES
    ('Ben','2006-08-30',152),
    ('Suzi','2006-08-29',391),
    ('Henry','2006-08-29',300),
    ('Henry','2006-08-27',96),
    ('Ben','2006-08-29',131),
    ('Henry','2006-08-26',115),
    ('Suzi','2006-09-02',502),
    ('Henry','2006-09-01',197),
    ('Ben','2006-09-02',79),
    ('Henry','2006-08-30',203)
;

SELECT * FROM driver_log;
SELECT * FROM driver_log
ORDER BY name, trav_date;

SELECT name, trav_date, DAYNAME(trav_date) FROM driver_log
ORDER BY name, trav_date;
