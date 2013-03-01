# housewares-b.sql

# Alternate representation of the housewares table.  It has the id
# column represented by three columns

DROP TABLE IF EXISTS housewares;
#@ _CREATE_TABLE_HOUSEWARES_
CREATE TABLE housewares
(
  category    VARCHAR(3) NOT NULL,
  serial      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  country     VARCHAR(2) NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY (category, country, serial)
);
#@ _CREATE_TABLE_HOUSEWARES_

# normally with a table like this, you'd set serial to NULL so that
# the values would be generated automatically as AUTO_INCREMENT values.
# They're set to specific values here to match the contents of the
# housewares table.

INSERT INTO housewares (category,serial,country,description)
  VALUES
    ('DIN', 40672, 'US', 'dining table'),
    ('KIT', 372, 'UK', 'garbage disposal'),
    ('KIT', 1729, 'JP', 'microwave oven'),
    ('BED', 38, 'SG', 'bedside lamp'),
    ('BTH', 485, 'US', 'shower stall'),
    ('BTH', 415, 'JP', 'lavatory')
;

SELECT * FROM housewares;
