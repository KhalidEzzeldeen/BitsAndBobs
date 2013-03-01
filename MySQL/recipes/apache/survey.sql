# survey.sql

# These queries show how to summarize survey response.  The queries
# differ according to how the responses were stored.  The results
# should be the same each way, however.  (Actually, there is one
# difference.  For items that were never chosen, they'll show up
# in the result from the first query with a count of zero.  They
# won't show up at all in the second query.)

# In the survey_choice table, each record has a column indicating the
# number of times the choice was selected:

SELECT q_id AS Question, c_id AS Choice, c_tally AS Votes
FROM survey_choice ORDER BY q_id, c_id;

# In the survey_response, each selection is represented by a separate
# record, so it's necessary to sum them:

SELECT q_id AS Question, c_id AS Choice, COUNT(*) AS Votes
FROM survey_response GROUP BY q_id, c_id;
