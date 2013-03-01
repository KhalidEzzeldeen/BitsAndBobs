# tsdemo2.sql

# Using a TIMESTAMP column that auto-initializes but does not auto-update.

# SET @dummy = SLEEP(5) serves to introduce a pause into
# the script so that time passes between statements.

DROP TABLE IF EXISTS tsdemo2;
#@ _CREATE_TABLE_
CREATE TABLE tsdemo2
(
  t_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  val      INT
);
#@ _CREATE_TABLE_

INSERT INTO tsdemo2 (val) VALUES(5);
SET @dummy = SLEEP(5);
INSERT INTO tsdemo2 (t_create,val) VALUES(NULL, 10);

SELECT * FROM tsdemo2;

# change the record to demonstrate that the TIMESTAMP column is not modified

SET @dummy = SLEEP(5);
UPDATE tsdemo2 SET val = 6 WHERE val = 5;
SELECT * FROM tsdemo2;
