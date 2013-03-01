# housewares.sql

# housewares catalogs:
# housewares: fixed-length id substrings
# housewares2: like housewares, but serial number part of id
#   has no leading zeros
# housewares3: id in n-n-n-n format

# Note: The sequences chapter describes how to convert the housewares.id
# column to use three separate columns by means of ALTER TABLE and some
# other statements.  If you've issued those statements, the table will
# no longer have the structure shown below.  To return the table to its
# original form, just rerun this script.


DROP TABLE IF EXISTS housewares;
CREATE TABLE housewares
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares (id,description)
  VALUES
    ('DIN40672US', 'dining table'),
    ('KIT00372UK', 'garbage disposal'),
    ('KIT01729JP', 'microwave oven'),
    ('BED00038SG', 'bedside lamp'),
    ('BTH00485US', 'shower stall'),
    ('BTH00415JP', 'lavatory')
;

SELECT * FROM housewares;

DROP TABLE IF EXISTS housewares2;
CREATE TABLE housewares2
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares2 (id,description)
  VALUES
    ('DIN40672US', 'dining table'),
    ('KIT372UK', 'garbage disposal'),
    ('KIT1729JP', 'microwave oven'),
    ('BED38SG', 'bedside lamp'),
    ('BTH485US', 'shower stall'),
    ('BTH415JP', 'lavatory')
;

SELECT * FROM housewares2;

# housewares3 table
# NEED BETTER NAME


DROP TABLE IF EXISTS housewares3;
CREATE TABLE housewares3
(
  id      VARCHAR(20),
  description VARCHAR(255)
);

INSERT INTO housewares3 (id,description)
  VALUES
    ('13-478-92-2', 'dining table'),
    ('873-48-649-63', 'garbage disposal'),
    ('8-4-2-1', 'microwave oven'),
    ('97-681-37-66', 'bedside lamp'),
    ('27-48-534-2', 'shower stall'),
    ('5764-56-89-72', 'lavatory')
;

SELECT * FROM housewares3;

DROP TABLE IF EXISTS hw_category;
CREATE TABLE hw_category
(
  abbrev  VARCHAR(3),
  name  VARCHAR(20)
);

INSERT INTO hw_category (abbrev,name)
  VALUES
    ('DIN', 'dining'),
    ('KIT', 'kitchen'),
    ('BTH', 'bathroom'),
    ('BED', 'bedroom')
;

SELECT * FROM hw_category;
