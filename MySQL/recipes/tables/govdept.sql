# govdept.sql

DROP TABLE IF EXISTS govdept;
#@ _CREATE_TABLE_
CREATE TABLE govdept
(
  name    VARCHAR(60) NOT NULL,
  email   VARCHAR(60),
  description TEXT
);
#@ _CREATE_TABLE_

INSERT INTO govdept (name, email, description)
VALUES
  ('White House','info@whitehouse.gov',
'The President\'s web site
is http://www.whitehouse.gov and you
can send email to the President or the First Lady
at president@whitehouse.gov or
first.lady@whitehouse.gov.'),
  ('House of Representatives','info@house.gov',NULL),
  ('Senate','info@senate.gov',NULL),
  ('Internal Revenue Service',NULL,NULL)
;

SELECT * FROM govdept;
