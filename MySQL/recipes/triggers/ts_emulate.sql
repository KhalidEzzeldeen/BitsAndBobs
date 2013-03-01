# ts_emulate.sql

# Emulate TIMESTAMP properties for other temporal data types by using
# triggers.


DROP TABLE IF EXISTS ts_emulate;
#@ _CREATE_TABLE_
CREATE TABLE ts_emulate
(
  data CHAR(10),
  d    DATE,
  t    TIME,
  dt   DATETIME
);
#@ _CREATE_TABLE_

# Set up BEFORE INSERT trigger that supplies default values of current
# date and time for non-TIMESTAMP temporal columns.

#@ _BEFORE_INSERT_TRIGGER_
CREATE TRIGGER bi_ts_emulate BEFORE INSERT ON ts_emulate
FOR EACH ROW SET NEW.d = CURDATE(), NEW.t = CURTIME(), NEW.dt = NOW();
#@ _BEFORE_INSERT_TRIGGER_

# Set up BEFORE UPDATE trigger that supplies default values of current
# date and time for non-TIMESTAMP temporal columns when data column changes.

delimiter $$

#@ _BEFORE_UPDATE_TRIGGER_
CREATE TRIGGER bu_ts_emulate BEFORE UPDATE ON ts_emulate
FOR EACH ROW
BEGIN
  # update temporal columns only if the nontemporal column changes
  IF NEW.data <> OLD.data THEN
    SET NEW.d = CURDATE(), NEW.t = CURTIME(), NEW.dt = NOW();
  END IF;
END;
#@ _BEFORE_UPDATE_TRIGGER_
$$

delimiter ;

# Create a couple of new rows

INSERT INTO ts_emulate (data) VALUES('cat');
SET @dummy = SLEEP(5);
INSERT INTO ts_emulate (data) VALUES('dog');
SELECT * FROM ts_emulate;

# Issue an update that changes the data column of a record

SET @dummy = SLEEP(5);
UPDATE ts_emulate SET data = 'axolotl' WHERE data = 'cat';
SELECT * FROM ts_emulate;

# Issue an update that doesn't change the data column

SET @dummy = SLEEP(5);
UPDATE ts_emulate SET data = data;
SELECT * FROM ts_emulate;
