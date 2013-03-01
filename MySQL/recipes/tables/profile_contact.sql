# profile_contact.sql

DROP TABLE IF EXISTS profile_contact;
#@ _CREATE_TABLE_
CREATE TABLE profile_contact
(
  profile_id   INT UNSIGNED NOT NULL, # ID from profile table
  service      CHAR(20) NOT NULL,     # messaging service name
  contact_name CHAR(25) NOT NULL,     # name to use for contacting person
  INDEX (profile_id)
);
#@ _CREATE_TABLE_



INSERT INTO profile_contact
  VALUES
    (1, 'AIM', 'user1-aimid'),
    (1, 'MSN', 'user1-msnid'),
    (2, 'AIM', 'user2-aimid'),
    (2, 'MSN', 'user2-msnid'),
    (2, 'Yahoo', 'user2-yahooid'),
    (4, 'Yahoo', 'user4-yahooid')
;

SELECT * FROM profile_contact;
