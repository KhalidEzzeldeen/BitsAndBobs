<?php
# rank.php - assign ranks to a set of values

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

# drop and recreate the t table, and then populate it

$result =& $conn->query ("DROP TABLE IF EXISTS t");
if (PEAR::isError ($result))
  die ("Cannot issue DROP TABLE statement\n");
$result =& $conn->query ("CREATE TABLE t (score INT)");
if (PEAR::isError ($result))
  die ("Cannot issue CREATE TABLE statement\n");
$result =& $conn->query (
      "INSERT INTO t (score) VALUES(5),(4),(4),(3),(2),(2),(2),(1)");
if (PEAR::isError ($result))
  die ("Cannot issue INSERT statement\n");

# Assign ranks using position (row number) within the set of values,
# except that tied values all get the rank accorded the first of them.

#@ _ASSIGN_RANKS_
$result =& $conn->query ("SELECT score FROM t ORDER BY score DESC");
if (PEAR::isError ($result))
  die ("Cannot select scores\n");
$rownum = 0;
$rank = 0;
unset ($prev_score);
print ("Row\tRank\tScore\n");
while (list ($score) = $result->fetchRow ())
{
  ++$rownum;
  if ($rownum == 1 || $prev_score != $score)
    $rank = $rownum;
  print ("$rownum\t$rank\t$score\n");
  $prev_score = $score;
}
$result->free ();
#@ _ASSIGN_RANKS_

$conn->disconnect ();

?>
