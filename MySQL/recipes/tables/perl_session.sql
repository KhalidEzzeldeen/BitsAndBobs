# perl_session.sql

# Structure for perl_session table for Apache::Session

# This requires a version of Apache::Session that supports
# the TableName argument when you open a session.  Otherwise,
# you need to edit the statements below to name the table
# as "sessions".

DROP TABLE IF EXISTS perl_session;
#@ _CREATE_TABLE_
CREATE TABLE perl_session
(
  id        CHAR(32) NOT NULL,  # session identifier
  a_session MEDIUMBLOB,         # session data
  PRIMARY KEY (id)
);
#@ _CREATE_TABLE_

# add a timestamp column

#@ _ALTER_TABLE_
ALTER TABLE perl_session ADD t TIMESTAMP NOT NULL, ADD INDEX (t);
#@ _ALTER_TABLE_
