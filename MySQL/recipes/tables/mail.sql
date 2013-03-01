# mail.sql

# Create and populate example table that represents a log of mail sent
# among three machines (saturn, mars, venus) by four users (barb,
# tricia, phil, and gene), each of whom has an account on each machine.

# Comparisons:
# - mail sent to/by a given user, one/any host
# - mail sent to self, any host
# - mail sent to self, same host

# Sorts:
# - sort by mail sender/recipient

# Summaries:
# - Number of messages from each host/user
# - Amount of mail sent to/from user
# - Amount of mail per day (chop off barbe)
# - Largest message per user/recipient
# - Ave message size overall/per host/per user

# LIMIT
# - 5 largest/smallest messages

DROP TABLE IF EXISTS mail;
#@ _CREATE_TABLE_
CREATE TABLE mail
(
  t       DATETIME, # when message was sent
  srcuser CHAR(8),  # sender (source user and host)
  srchost CHAR(20),
  dstuser CHAR(8),  # recipient (destination user and host)
  dsthost CHAR(20),
  size    BIGINT,   # message size in bytes
  INDEX (t)
);
#@ _CREATE_TABLE_

INSERT INTO mail (t,srchost,srcuser,dsthost,dstuser,size)
  VALUES
    ('2006-05-11 10:15:08','saturn','barb','mars','tricia',58274),
    ('2006-05-12 12:48:13','mars','tricia','venus','gene',194925),
    ('2006-05-12 15:02:49','mars','phil','saturn','phil',1048),
    ('2006-05-13 13:59:18','saturn','barb','venus','tricia',271),
    ('2006-05-14 09:31:37','venus','gene','mars','barb',2291),
    ('2006-05-14 11:52:17','mars','phil','saturn','tricia',5781),
    ('2006-05-14 14:42:21','venus','barb','venus','barb',98151),
    ('2006-05-14 17:03:01','saturn','tricia','venus','phil',2394482),
    ('2006-05-15 07:17:48','mars','gene','saturn','gene',3824),
    ('2006-05-15 08:50:57','venus','phil','venus','phil',978),
    ('2006-05-15 10:25:52','mars','gene','saturn','tricia',998532),
    ('2006-05-15 17:35:31','saturn','gene','mars','gene',3856),
    ('2006-05-16 09:00:28','venus','gene','mars','barb',613),
    ('2006-05-16 23:04:19','venus','phil','venus','barb',10294),
    ('2006-05-17 12:49:23','mars','phil','saturn','tricia',873),
    ('2006-05-19 22:21:51','saturn','gene','venus','gene',23992)
;
