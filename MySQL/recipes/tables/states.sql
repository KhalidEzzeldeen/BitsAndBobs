# states.sql

# U.S. states table:
# full name, abbreviation, date of statehood (entry into the Union),
# population estimate as of 2004-07-01.
# Population values were taken from U.S. Census Bureau:
# http://www.census.gov/

DROP TABLE IF EXISTS states;
#@ _CREATE_TABLE_
CREATE TABLE states
(
  name      VARCHAR(30) NOT NULL, # state name
  abbrev    CHAR(2) NOT NULL,     # 2-letter abbreviation
  statehood DATE,                 # date of entry into the Union
  pop       BIGINT,               # population as of 2004-07-01
  PRIMARY KEY (abbrev)
);
#@ _CREATE_TABLE_

LOAD DATA LOCAL INFILE 'states.txt' INTO TABLE states;
