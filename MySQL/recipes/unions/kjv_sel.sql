# kjv_sel.sql

# Check index usage for various queries, specified either by a complex
# WHERE or by using UNION.

# Single-book query, no chapter qualifiers

EXPLAIN SELECT * FROM kjv WHERE bnum = 14;

# Multiple-book query, no chapter qualifiers
# (can be expressed using only AND)

EXPLAIN SELECT * FROM kjv WHERE 14 <= bnum AND bnum <= 16;

# Single-book query, with chapter qualifier
# (still can be expressed using only AND)

EXPLAIN SELECT * FROM kjv WHERE bnum = 14 AND 2 <= cnum AND cnum <= 12;

# Multiple-book query, with chapter qualifier such that the WHERE
# now requires an OR.  (book 14, chapter 2 through book 26, chapter 9)
# At this point, the optimizer gives up and must perform a table scan.

EXPLAIN SELECT * FROM kjv
WHERE (bnum = 14 AND 2 <= cnum)
OR (bnum > 14 AND bnum < 26)
OR (bnum = 26 AND cnum < 9);

# Multiple-book query, with chapter qualifier, but now expressed as
# a UNION of three simpler SELECT statements that don't mix AND and OR.
# Now the optimizer can use the index for the separate SELECT statements.

EXPLAIN SELECT * FROM kjv WHERE bnum = 14 AND 2 <= cnum
UNION SELECT * FROM kjv WHERE bnum > 14 AND bnum < 26
UNION SELECT * FROM kjv WHERE bnum = 26 AND cnum < 9;

# On the other hand, this doesn't mean that the UNION will in fact
# be faster.  Depending on the query, the overhead from combining the
# result sets may still make the UNION slower.
