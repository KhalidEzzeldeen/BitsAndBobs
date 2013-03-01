<?php
# shuffle_deck.php - shuffle the deck table and display resulting card order

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

# "shuffle" the deck by randomizing it, and then
# print card information

#@ _SHUFFLE_DECK_
function shuffle_deck ($conn)
{
  $result =& $conn->query ("SELECT face, suit FROM deck ORDER BY RAND()");
  if (PEAR::isError ($result))
    die ("Cannot retrieve cards from deck\n");
  $card = array ();
  while ($obj =& $result->fetchRow (DB_FETCHMODE_OBJECT))
    $card[] = $obj;   # add card record to end of $card array
  $result->free ();
  return ($card);
}
#@ _SHUFFLE_DECK_

$card = shuffle_deck ($conn);
#@ _PRINT_ARRAY_
for ($i = 0; $i < count ($card); $i++)
  printf ("%s %s\n", $card[$i]->face, $card[$i]->suit);
#@ _PRINT_ARRAY_

$conn->disconnect ();

?>
