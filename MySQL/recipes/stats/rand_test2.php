<?php
# rand_test2.php - create a frequency distribution of RAND() values.
# This provides a test of the randomness of RAND().

$nchoices = 10;     # how many different numbers to allow
$npicks = 1000;   # number of times to pick a number

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

# drop and recreate the t table, and then populate it

$result =& $conn->query ("DROP TABLE IF EXISTS t");
if (PEAR::isError ($result))
  die ("Cannot issue DROP TABLE statement\n");
$result =& $conn->query ("CREATE TABLE t (num INT, counter INT)");
if (PEAR::isError ($result))
  die ("Cannot issue CREATE TABLE statement\n");

# populate the table with rows numbered 1 through $nchoices, each
# initialized with a counter value of zero

for ($i = 1; $i <= $nchoices; $i++)
{
  $result =& $conn->query ("INSERT INTO t (num,counter) VALUES($i,0)");
  if (PEAR::isError ($result))
    die ("Cannot insert card into t\n");
}

# Now run a zillion picks and count how many times each item gets picked

# If the upper loop boundary is too high, the script may time out.

for ($i = 0; $i < $npicks; $i++)
{
  $result =& $conn->query ("SELECT num FROM t
                            ORDER BY RAND() LIMIT 1");
  if (PEAR::isError ($result))
    die ("Cannot select random number\n");
  $row =& $result->fetchRow ();
  $result->free ();
  # update count for selected value
  $result =& $conn->query ("UPDATE t SET counter = counter + 1
                            WHERE num = $row[0]");
  if (PEAR::isError ($result))
  die ("Cannot update counter\n");
}

# Print the resulting frequency distribution

$result =& $conn->query ("SELECT num, counter FROM t ORDER BY num");
if (PEAR::isError ($result))
  die ("Cannot select frequency distribution results\n");
while (list ($num, $counter) = $result->fetchRow ())
  printf ("%2d  %d\n", $num, $counter);
$result->free ();

# Display total number of choices and standard deviation of distribution

$result =& $conn->query ("SELECT SUM(counter), STD(counter) FROM t");
if (PEAR::isError ($result))
  die ("Cannot select n, standard deviation\n");
list ($n, $stddev) = $result->fetchRow ();
$result->free ();
print ("total number of selections: $n\n");
print ("standard deviation of selections: $stddev\n");

$conn->disconnect ();

?>
