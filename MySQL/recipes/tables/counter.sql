# counter.sql

# create counter table to test how deep mysql can nest source'd files

DROP TABLE IF EXISTS counter;
#@ _FRAG_
CREATE TABLE counter (depth INT);
INSERT INTO counter SET depth = 0;
#@ _FRAG_
