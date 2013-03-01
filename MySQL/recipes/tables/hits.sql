# hits.sql

# Web page hit-counter and hit-logging tables
# These should both be created at the same time so that the hits columns
# of each remain in sync when the tables are accessed by the
# hits.{pl,php,py,rb,jsp} scripts.

DROP TABLE IF EXISTS hitcount;
#@ _CREATE_HITCOUNT_TABLE_
CREATE TABLE hitcount
(
  path  VARCHAR(255)
        CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  hits  BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (path)
);
#@ _CREATE_HITCOUNT_TABLE_

# This uses a multiple-column sequence index to serve the dual purpose
# of logging requests and generating the hit count per page.
# Use MyISAM explicitly because this table requires the ability to
# create a composite index that contains an AUTO_INCREMENT column.

DROP TABLE IF EXISTS hitlog;
#@ _CREATE_HITLOG_TABLE_
CREATE TABLE hitlog
(
  path  VARCHAR(255)
        CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  hits  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  t     TIMESTAMP,
  host  VARCHAR(255),
  INDEX (path,hits)
) ENGINE = MyISAM;
#@ _CREATE_HITLOG_TABLE_
