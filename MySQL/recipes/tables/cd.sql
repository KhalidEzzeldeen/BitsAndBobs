# cd.sql

# example cd table for the eponymy example

DROP TABLE IF EXISTS cd;
#@ _CREATE_TABLE_
CREATE TABLE cd
(
  year    INT UNSIGNED, # year of issue
  artist  VARCHAR(50),  # artist or group name
  title   VARCHAR(50)   # album title
);
#@ _CREATE_TABLE_

INSERT INTO cd (year,artist,title) VALUES
(1990,'Iona','Iona'),
(1999,'Charlie Peacock','Kingdom Come'),
(2001,'Iona','Open Sky'),
(1987,'The 77s','The 77s'),
(2004,'Dave Bainbridge','Veil of Gossamer'),
(1989,'Richard Souther','Cross Currents'),
(1999,'Adrian Snell','City of Peace'),
(1982,'Undercover','Undercover'),
(1998,'jaci velasquez','jaci velasquez')
;

# select all rows

SELECT year, artist, title FROM cd;

# select eponymous rows (where the title is the same as the artist)

SELECT year, artist, title FROM cd WHERE artist = title;
