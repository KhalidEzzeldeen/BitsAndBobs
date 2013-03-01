# new_log_entries.sql

#@ _FRAG_
SELECT COUNT(*) As 'New log entries:'
FROM log_tbl
WHERE date_added = DATE_SUB(CURDATE(),INTERVAL 1 DAY);
#@ _FRAG_
