# kjv.sql

# Table to hold King James Version of Bible

DROP TABLE IF EXISTS kjv;
#@ _CREATE_TABLE_
CREATE TABLE kjv
(
	bsect ENUM('O', 'N') NOT NULL,		# book section (old or new test.)
	bname VARCHAR(20) NOT NULL, 		# book name
	bnum  TINYINT UNSIGNED NOT NULL,	# book number
	cnum  TINYINT UNSIGNED NOT NULL,	# chapter number
	vnum  TINYINT UNSIGNED NOT NULL,	# verse number
	vtext TEXT NOT NULL					# text of verse
) ENGINE = MyISAM

# then do this in MySQL interface:
# LOAD DATA LOCAL INFILE '/Users/sinn/Documents/MySQL/mcb-kjv/kjv.txt' INTO TABLE kjv;
# then do this to prep for FULLTEXT searches…
# ALTER TABLE kjv ADD FULLTEXT (vtext);
