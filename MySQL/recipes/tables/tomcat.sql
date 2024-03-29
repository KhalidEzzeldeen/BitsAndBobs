# tomcat.sql

# Tables for Tomcat JDBCRealm authentication

DROP TABLE IF EXISTS tomcat_user;
#@ _CREATE_USER_TABLE_
CREATE TABLE tomcat_user
(
  user_name VARCHAR(30) NOT NULL,
  user_pass VARCHAR(30) NOT NULL,
  PRIMARY KEY (user_name)
);
#@ _CREATE_USER_TABLE_

DROP TABLE IF EXISTS tomcat_role;
#@ _CREATE_ROLE_TABLE_
CREATE TABLE tomcat_role
(
  user_name VARCHAR(30) NOT NULL,
  role_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (user_name, role_name)
);
#@ _CREATE_ROLE_TABLE_

# Add a user with the "manager" role for the Tomcat manager application
# (Note: you probably want to change these values so that other people
# can't connect to your Tomcat server and use your manager app!)

INSERT INTO tomcat_user (user_name, user_pass)
  VALUES ('mgr_user', 'mgr_pass');
INSERT INTO tomcat_role (user_name, role_name)
  VALUES ('mgr_user', 'manager');

SELECT * FROM tomcat_user;
SELECT * FROM tomcat_role;

# Tables for Tomcat session management

DROP TABLE IF EXISTS tomcat_session;
#@ _CREATE_SESSION_TABLE_
CREATE TABLE tomcat_session
(
  id            VARCHAR(32) NOT NULL,
  app           VARCHAR(255),
  data          MEDIUMBLOB,
  valid_session CHAR(1) NOT NULL,
  max_inactive  INT NOT NULL,
  last_access   BIGINT NOT NULL,
  PRIMARY KEY (id),
  INDEX (app)
);
#@ _CREATE_SESSION_TABLE_
