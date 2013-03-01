# profile.sql

DROP TABLE IF EXISTS profile;
#@ _CREATE_TABLE_
CREATE TABLE profile
(
  id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name  CHAR(20) NOT NULL,
  birth DATE,
  color ENUM('blue','red','green','brown','black','white'),
  foods SET('lutefisk','burrito','curry','eggroll','fadge','pizza'),
  cats  INT,
  PRIMARY KEY (id)
);
#@ _CREATE_TABLE_

INSERT INTO profile
  VALUES
    (NULL,'Fred','1970-04-13','black','lutefisk,pizza,fadge',0),
    (NULL,'Mort','1969-09-30','white','curry,eggroll,burrito',3),
    (NULL,'Brit','1957-12-01','red','burrito,pizza,curry',1),
    (NULL,'Carl','1973-11-02','red','pizza,eggroll',4),
    (NULL,'Sean','1963-07-04','blue','burrito,curry',5),
    (NULL,'Alan','1965-02-14','red','curry,fadge',1),
    (NULL,'Mara','1968-09-17','green','fadge,lutefisk',1),
    (NULL,'Shepard','1975-09-02','black','pizza,curry',2),
    (NULL,'Dick','1952-08-20','green','fadge,lutefisk',0),
    (NULL,'Tony','1960-05-01','white','pizza,burrito',0)
;

SELECT * FROM profile;
