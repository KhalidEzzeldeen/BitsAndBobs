# meeting.sql

# Table containing tickets left for meetings and conventions.
# It goes with the get_ticket.php application in the transaction
# directory.  One of the demonstration functions shows a transactional
# implementation, so this table should be created with a transactional
# type if possible.

DROP TABLE IF EXISTS meeting;
#@ _CREATE_TABLE_
CREATE TABLE meeting
(
  meeting_id  INT UNSIGNED NOT NULL,
  PRIMARY KEY (meeting_id),
  tix_left    INT UNSIGNED NOT NULL
)
ENGINE = InnoDB;
#@ _CREATE_TABLE_

INSERT INTO meeting (meeting_id, tix_left) VALUES (53, 100);
INSERT INTO meeting (meeting_id, tix_left) VALUES (72, 50);
INSERT INTO meeting (meeting_id, tix_left) VALUES (91, 150);
INSERT INTO meeting (meeting_id, tix_left) VALUES (102, 0);

SELECT * FROM meeting;
