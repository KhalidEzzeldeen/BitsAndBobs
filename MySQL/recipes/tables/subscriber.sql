# subscriber.sql

DROP TABLE IF EXISTS subscriber;
#@ _CREATE_TABLE_
CREATE TABLE subscriber
(
  name  VARCHAR(40),
  email VARCHAR(60)
  /* possibly other columns here */
);
#@ _CREATE_TABLE_

INSERT INTO subscriber (name,email)
  VALUES
    ('The President','president@whitehouse.gov'),
    ('The Vice President','vice.president@whitehouse.gov'),
    ('The First Lady','first.lady@whitehouse.gov'),
    ('Bob',NULL)
;
