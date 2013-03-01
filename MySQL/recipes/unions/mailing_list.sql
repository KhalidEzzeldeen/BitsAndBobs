# mailing_list.sql

# Problem: create a single mailing list from three disparate tables:
# - prospect: prospective customers
# - customer: actual customers
# - supplier: supply vendors

# There may be overlap between this, for example if a prospective customer
# has recently become an actual customer, but the prospect record hasn't
# yet been deleted.

# The values needed for the mailing list are name and address.  For
# simplicity, the example use only street address and not city, state,
# etc.

DROP TABLE IF EXISTS prospect;
CREATE TABLE prospect
(
  fname CHAR(40),
  lname CHAR(40),
  addr  CHAR(40)
);

DROP TABLE IF EXISTS customer;
CREATE TABLE customer
(
  last_name   CHAR(40),
  first_name  CHAR(40),
  address     CHAR(40)
);

DROP TABLE IF EXISTS vendor;
CREATE TABLE vendor
(
  company CHAR(60),
  street  CHAR(30)
);

INSERT INTO prospect (fname, lname, addr)
  VALUES
    ('Peter','Jones','482 Rush St., Apt. 402'),
    ('Bernice','Smith','916 Maple Dr.')
;

INSERT INTO customer (first_name, last_name, address)
  VALUES
    ('Grace','Peterson','16055 Seminole Ave.'),
    ('Bernice','Smith','916 Maple Dr.'),
    ('Walter','Brown','8602 1st St.')
;

INSERT INTO vendor (company, street)
  VALUES
    ('ReddyParts, Inc.','38 Industrial Blvd.'),
    ('Parts-to-go, Ltd.','213B Commerce Park.')
;

SELECT fname, lname, addr FROM prospect
UNION
SELECT first_name, last_name, address FROM customer
UNION
SELECT company, '', street FROM vendor
;

SELECT fname, lname, addr FROM prospect
UNION ALL
SELECT first_name, last_name, address FROM customer
UNION ALL
SELECT company, '', street FROM vendor
;

SELECT CONCAT(lname,', ',fname) AS name, addr FROM prospect
UNION
SELECT CONCAT(last_name,', ',first_name), address FROM customer
UNION
SELECT company, street FROM vendor
;

(SELECT CONCAT(lname,', ',fname) AS name, addr FROM prospect)
UNION
(SELECT CONCAT(last_name,', ',first_name), address FROM customer)
UNION
(SELECT company, street FROM vendor)
ORDER BY name
;

(SELECT CONCAT(lname,', ',fname) AS name, addr
FROM prospect ORDER BY name)
UNION
(SELECT CONCAT(last_name,', ',first_name) AS name, address
FROM customer ORDER BY name)
UNION
(SELECT company, street FROM vendor ORDER BY company)
;
