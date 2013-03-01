<?php
# create_deck.php - create a deck table and populate it with cards
# (13 faces, 4 suits)

require_once "Cookbook.php";

$conn =& Cookbook::connect ();
if (PEAR::isError ($conn))
  die ("Cannot connect to server: " . $conn->getMessage ());

# drop and recreate the deck table, and then populate it

$result =& $conn->query ("DROP TABLE IF EXISTS deck");
if (PEAR::isError ($result))
  die ("Cannot issue DROP TABLE statement\n");
#@ _CREATE_TABLE_
$result =& $conn->query ("
              CREATE TABLE deck
              (
                face  ENUM('A', 'K', 'Q', 'J', '10', '9', '8',
                           '7', '6', '5', '4', '3', '2') NOT NULL,
                suit  ENUM('hearts', 'diamonds', 'clubs', 'spades') NOT NULL
              )");
if (PEAR::isError ($result))
  die ("Cannot issue CREATE TABLE statement\n");

$face_array = array ("A", "K", "Q", "J", "10", "9", "8",
                     "7", "6", "5", "4", "3", "2");
$suit_array = array ("hearts", "diamonds", "clubs", "spades");

# insert a "card" into the deck for each combination of suit and face

$stmt =& $conn->prepare ("INSERT INTO deck (face,suit) VALUES(?,?)");
if (PEAR::isError ($stmt))
  die ("Cannot insert card into deck\n");
foreach ($face_array as $index => $face)
{
  foreach ($suit_array as $index2 => $suit)
  {
    $result =& $conn->execute ($stmt, array ($face, $suit));
    if (PEAR::isError ($result))
      die ("Cannot insert card into deck\n");
  }
}
#@ _CREATE_TABLE_

$conn->disconnect ();

?>
