# kjv.sql

# table to hold verses of the King James Version of the Bible

# Table must be created explicitly as MyISAM because it'll be given
# a FULLTEXT index, which can be used only for MyISAM tables.

DROP TABLE IF EXISTS kjv;
#@ _CREATE_TABLE_
CREATE TABLE kjv
(
  bsect ENUM('O','N') NOT NULL,       # book section (testament)
  bname VARCHAR(20) NOT NULL,         # book name
  bnum  TINYINT UNSIGNED NOT NULL,    # book number
  cnum  TINYINT UNSIGNED NOT NULL,    # chapter number
  vnum  TINYINT UNSIGNED NOT NULL,    # verse number
  vtext TEXT NOT NULL                 # text of verse
) ENGINE = MyISAM;
#@ _CREATE_TABLE_
