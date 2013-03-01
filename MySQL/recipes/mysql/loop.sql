# loop.sql

# increment nesting level, display current depth, and then source myself
#@ _FRAG_
UPDATE counter SET depth = depth + 1;
SELECT depth FROM counter;
SOURCE loop.sql;
#@ _FRAG_
