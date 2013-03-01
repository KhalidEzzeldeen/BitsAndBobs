# prospect.sql

DROP TABLE IF EXISTS prospect;
CREATE TABLE prospect
(
  fname  VARCHAR(20),
  lname  VARCHAR(20),
  addr   VARCHAR(40)
);

INSERT INTO prospect VALUES
  ('Peter','Jones','482 Rush St., Apt. 402'),
  ('Bernice','Smith','916 Maple Dr.');

DROP TABLE IF EXISTS customer;
CREATE TABLE customer
(
  last_name   VARCHAR(20),
  first_name  VARCHAR(20),
  address     VARCHAR(40)
);

INSERT INTO customer VALUES
  ('Peterson','Grace','16055 Seminole Ave.'),
  ('Smith','Bernice','916 Maple Dr.'),
  ('Brown','Walter','8602 1st St.');

DROP TABLE IF EXISTS vendor;
CREATE TABLE vendor
(
  company  VARCHAR(40),
  street   VARCHAR(40)
);

INSERT INTO vendor VALUES
  ('ReddyParts, Inc.','38 Industrial Blvd.'),
  ('Parts-to-go, Ltd.','213B Commerce Park.');

SELECT * FROM prospect;
SELECT * FROM customer;
SELECT * FROM vendor;
