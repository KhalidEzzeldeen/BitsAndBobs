# survey.sql

# Tables for performing a survey consisting of multiple-choice questions:
# - survey_questions - text of each question
# - survey_choices - possible choices for each question
# - survey_responses - vote-tallying table

# NOTE: survey_choices uses multiple-column sequence table,
# which requires MySQL 3.22.25 or later.

# The survey_choice table includes a c_tally column that is used
# to show how to record number of votes for a choice directly in
# that table.  The survey_response table records votes, too, but
# it records each vote in an individual record.  This is done to
# show two ways of tallying votes.

DROP TABLE IF EXISTS survey_question;
#@ _CREATE_TABLE_
CREATE TABLE survey_question
(
  q_id    INT UNSIGNED NOT NULL AUTO_INCREMENT, # question ID
  PRIMARY KEY (q_id),
  q_text  VARCHAR(255) NOT NULL                 # question text
);
#@ _CREATE_TABLE_

DROP TABLE IF EXISTS survey_choice;
#@ _CREATE_TABLE_
CREATE TABLE survey_choice
(
  q_id    INT UNSIGNED NOT NULL,                # question ID
  c_id    INT UNSIGNED NOT NULL AUTO_INCREMENT, # choice ID
  PRIMARY KEY (q_id, c_id),
  c_text  VARCHAR(255) NOT NULL,                # choice text
  c_tally INT UNSIGNED NOT NULL                 # how many times chosen
);
#@ _CREATE_TABLE_

INSERT INTO survey_question (q_text)
  VALUES('How did you hear about us?');
INSERT INTO survey_choice (q_id,c_text,c_tally)
  VALUES
    (LAST_INSERT_ID(),'magazine',0),
    (LAST_INSERT_ID(),'web site',0),
    (LAST_INSERT_ID(),'direct mail',0),
    (LAST_INSERT_ID(),'friend',0)
;
INSERT INTO survey_question (q_text)
  VALUES('How many employees are in your company?');
INSERT INTO survey_choice (q_id,c_text,c_tally)
  VALUES
    (LAST_INSERT_ID(),'1-9',0),
    (LAST_INSERT_ID(),'10-99',0),
    (LAST_INSERT_ID(),'100-499',0),
    (LAST_INSERT_ID(),'500-999',0),
    (LAST_INSERT_ID(),'more than 1000',0)
;

SELECT * FROM survey_question;
SELECT * FROM survey_choice;

# This is a very basic response-recording that just associates
# a response with each question.  A real table might record a
# client ID, time of response, etc.

DROP TABLE IF EXISTS survey_response;
#@ _CREATE_TABLE_
CREATE TABLE survey_response
(
  q_id  INT UNSIGNED NOT NULL,
  c_id  INT UNSIGNED NOT NULL,
  INDEX (q_id, c_id)
);
#@ _CREATE_TABLE_

SELECT * FROM survey_response;
