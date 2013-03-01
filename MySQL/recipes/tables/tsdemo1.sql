# tsdemo1.sql

# Using a single TIMESTAMP column to record time of record creation
# and most recent record modification

# SET @dummy = SLEEP(5) serves to introduce a pause into
# the script so that time passes between statements.

DROP TABLE IF EXISTS tsdemo1;
#@ _CREATE_TABLE_
CREATE TABLE tsdemo1
(
  ts  TIMESTAMP,
  val INT
);
#@ _CREATE_TABLE_

INSERT INTO tsdemo1 (val) VALUES(5);
SET @dummy = SLEEP(5);
INSERT INTO tsdemo1 (ts,val) VALUES(NULL, 10);

SELECT * FROM tsdemo1;

# change one record

SET @dummy = SLEEP(5);
UPDATE tsdemo1 SET val = 6 WHERE val = 5;
SELECT * FROM tsdemo1;

# change both records

SET @dummy = SLEEP(5);
UPDATE tsdemo1 SET val = 7;
SELECT * FROM tsdemo1;

# An update that changes no records (doesn't change the TIMESTAMP values)

SET @dummy = SLEEP(5);
UPDATE tsdemo1 SET val = val;
SELECT * FROM tsdemo1;
