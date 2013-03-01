<?php

# run a few null test operations

unset ($null);  # explicitly unset value

printf ("unset value === 0: %s\n", ($null === 0 ? "yes" : "no"));
printf ("unset value == 0: %s\n", ($null == 0 ? "yes" : "no"));
printf ("unset value === NULL: %s\n", ($null === NULL ? "yes" : "no"));
printf ("unset value == NULL: %s\n", ($null == NULL ? "yes" : "no"));
printf ("empty string === 0: %s\n", ("" === 0 ? "yes" : "no"));
printf ("empty string == 0: %s\n", ("" == 0 ? "yes" : "no"));

printf ("NULL === 0: %s\n", (NULL === 0 ? "yes" : "no"));
printf ("NULL == 0: %s\n", (NULL == 0 ? "yes" : "no"));
printf ("NULL === \"\": %s\n", (NULL === "" ? "yes" : "no"));
printf ("NULL == \"\": %s\n", (NULL == "" ? "yes" : "no"));
printf ("NULL === NULL: %s\n", (NULL === NULL ? "yes" : "no"));
printf ("NULL == NULL: %s\n", (NULL == NULL ? "yes" : "no"));

unset ($val);
if ($val === NULL)
{
  print ("unset val is NULL\n");
}
else
{
  print ("unset val is not NULL\n");
}
if (!isset ($val))
{
  print ("unset val is NULL\n");
}
else
{
  print ("unset val is not NULL\n");
}
#@ _NULL_TEST_1_
if ($val === NULL)
{
  # $val is a NULL value
}
#@ _NULL_TEST_1_
#@ _NULL_TEST_2_
if (!isset ($val))
{
  # $val is a NULL value
}
#@ _NULL_TEST_2_

?>
