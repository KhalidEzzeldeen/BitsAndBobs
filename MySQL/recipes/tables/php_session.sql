# php_session.sql

DROP TABLE IF EXISTS php_session;
#@ _CREATE_TABLE_
CREATE TABLE php_session
(
  id    CHAR(32) NOT NULL,
  data  MEDIUMBLOB,
  t     TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  INDEX (t)
);
#@ _CREATE_TABLE_
