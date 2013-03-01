# bug.sql

# Table like the insect table, but includes a two-part AUTO_INCREMENT index.

DROP TABLE IF EXISTS bug;
#@ _CREATE_TABLE_
CREATE TABLE bug
(
  id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name    VARCHAR(30) NOT NULL, # type of bug
  date    DATE NOT NULL,        # date collected
  origin  VARCHAR(30) NOT NULL, # where collected
  PRIMARY KEY (name, id)
);
#@ _CREATE_TABLE_

INSERT INTO bug (name,date,origin) VALUES
('ant','2006-10-07','kitchen'),
('millipede','2006-10-07','basement'),
('beetle','2006-10-07','basement'),
('ant','2006-10-07','front yard'),
('ant','2006-10-07','front yard'),
('honeybee','2006-10-08','back yard'),
('cricket','2006-10-08','garage'),
('beetle','2006-10-08','front yard'),
('termite','2006-10-09','kitchen woodwork'),
('cricket','2006-10-10','basement'),
('termite','2006-10-11','bathroom woodwork'),
('honeybee','2006-10-11','garden'),
('cricket','2006-10-11','garden'),
('ant','2006-10-11','garden')
;

SELECT * FROM bug;
SELECT * FROM bug ORDER BY name, id;
