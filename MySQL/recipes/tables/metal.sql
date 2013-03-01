# metal.sql

# This script creates the initial version of the metal table used in
# the strings chapter.  To alter it to include the binary string
# column, see metal_alter.sql.

DROP TABLE IF EXISTS metal;
#@ _CREATE_TABLE_
CREATE TABLE metal (name VARCHAR(20));
#@ _CREATE_TABLE_

# populate table

INSERT INTO metal (name)
  VALUES
    ('copper'),
    ('gold'),
    ('iron'),
    ('lead'),
    ('mercury'),
    ('platinum'),
    ('silver'),
    ('tin')
;

SELECT * FROM metal;
