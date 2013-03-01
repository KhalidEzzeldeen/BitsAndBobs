# Add indexes to the kjv table

ALTER TABLE kjv
	ADD INDEX (bnum),
	ADD INDEX (bsect),
	ADD INDEX (cnum),
	ADD INDEX (vnum),
	ADD FULLTEXT (vtext);
