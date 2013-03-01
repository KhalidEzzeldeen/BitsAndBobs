# fed_painting.sql

# FEDERATED painting table

# NOTE: that table won't work with the definition as shown.  You'll
# need to change the connection parameters so that they're appropriate
# for your system.

DROP TABLE IF EXISTS fed_painting;
#@ _CREATE_TABLE_
CREATE TABLE fed_painting
(
  a_id  INT UNSIGNED NOT NULL,                # artist ID
  p_id  INT UNSIGNED NOT NULL AUTO_INCREMENT, # painting ID
  title VARCHAR(100) NOT NULL,                # title of painting
  state VARCHAR(2) NOT NULL,                  # state where purchased
  price INT UNSIGNED,                         # purchase price (dollars)
  INDEX (a_id),
  PRIMARY KEY (p_id)
)
ENGINE = FEDERATED
CONNECTION = 'mysql://cbuser:cbpass@remote.example.com/cookbook/painting';
#@ _CREATE_TABLE_

