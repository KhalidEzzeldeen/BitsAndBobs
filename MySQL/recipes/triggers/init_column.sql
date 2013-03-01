# init_column.sql

# Use BEFORE INSERT trigger to provide nonconstant initial value
# for a column.


DROP TABLE IF EXISTS doc_table;
#@ _CREATE_TABLE_
CREATE TABLE doc_table
(
  author   VARCHAR(100) NOT NULL,
  title    VARCHAR(100) NOT NULL,
  document MEDIUMBLOB NOT NULL,
  doc_hash CHAR(32) NOT NULL,
  PRIMARY KEY (doc_hash)
);
#@ _CREATE_TABLE_

# Set up a BEFORE INSERT trigger that calculates the hash value for
# the document and stores it in the doc_hash column.

#@ _BEFORE_INSERT_TRIGGER_
CREATE TRIGGER bi_doc_table BEFORE INSERT ON doc_table
FOR EACH ROW SET NEW.doc_hash = MD5(NEW.document);
#@ _BEFORE_INSERT_TRIGGER_

# Set up a BEFORE UPDATE trigger that updates the hash value for
# the new document value and stores it in the doc_hash column.

#@ _BEFORE_UPDATE_TRIGGER_
CREATE TRIGGER bu_doc_table BEFORE UPDATE ON doc_table
FOR EACH ROW SET NEW.doc_hash = MD5(NEW.document);
#@ _BEFORE_UPDATE_TRIGGER_

# Create a new row

INSERT INTO doc_table (author,title,document)
VALUES('Mr. Famous Writer','My Life as a Writer','This is the document');
SELECT author, title, document, doc_hash, MD5(document) FROM doc_table\G

# Issue an update that changes the document column of a record

UPDATE doc_table SET document = 'A new document'
WHERE document = 'This is the document';
SELECT author, title, document, doc_hash, MD5(document) FROM doc_table\G

# Issue an update that doesn't change the document column

UPDATE doc_table SET document = document;
SELECT author, title, document, doc_hash, MD5(document) FROM doc_table\G
