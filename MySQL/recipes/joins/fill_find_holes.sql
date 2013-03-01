# fill_find_holes.sql

# Produce a master-detail summary using a reference table to make sure
# all categories appear in the summary.

# Problem: Summarize mail messages in the mail table to show how many
# messages were sent at each hour of the day.

# First try:

SELECT HOUR(t) AS hour, COUNT(HOUR(t)) AS count FROM mail GROUP BY hour;

# That doesn't work, because it doesn't show entries for hours of the day
# during which no messages were sent.  To fix that, create a reference
# table that lists each hour of the day, and LEFT JOIN it to the mail
# table.

DROP TABLE IF EXISTS ref;
CREATE TABLE ref (h INT);
INSERT INTO ref (h)
VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),
(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23);

SELECT ref.h AS hour, COUNT(HOUR(mail.t)) AS count
FROM ref LEFT JOIN mail ON ref.h = HOUR(mail.t)
GROUP BY hour;

# Now use the reference table to find holes in the hour-of-day category
# list (hours during which no messages were sent).

SELECT ref.h AS hour, COUNT(HOUR(mail.t)) AS count
FROM ref LEFT JOIN mail ON ref.h = HOUR(mail.t)
GROUP BY hour
HAVING count = 0;

# A simpler approach is to recognize that it's necessary only to look
# for reference table rows not matched by any mail table rows.  It's
# not necessary to actually summarize the mail records.

SELECT ref.h AS hour
FROM ref LEFT JOIN mail ON ref.h = HOUR(mail.t)
WHERE mail.t IS NULL;
