# passwd.sql

# create table for loading the /etc/passwd file (except the password field)

DROP TABLE IF EXISTS passwd;
#@ _CREATE_TABLE_
CREATE TABLE passwd
(
  account   CHAR(8),  # login name
  uid       INT,      # user ID
  gid       INT,      # group ID
  gecos     CHAR(60), # name, phone, office, etc.
  directory CHAR(60), # home directory
  shell     CHAR(60)  # command interpreter
);
#@ _CREATE_TABLE_
