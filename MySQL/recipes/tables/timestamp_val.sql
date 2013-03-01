# timestamp_val.sql

# table of test date-and-time values (same values as datetimes table,
# but as TIMESTAMP values)

DROP TABLE IF EXISTS timestamp_val;
CREATE TABLE timestamp_val
(
  ts  TIMESTAMP
);

# These values are the same for datetime_val and timestamp_val.
# Don't change one without changing the other.

INSERT INTO timestamp_val (ts) VALUES('1970-01-01 00:00:00');
INSERT INTO timestamp_val (ts) VALUES('1987-03-05 12:30:15');
INSERT INTO timestamp_val (ts) VALUES('1999-12-31 09:00:00');
INSERT INTO timestamp_val (ts) VALUES('2000-06-04 15:45:30');

SELECT * FROM timestamp_val;
