#!/usr/bin/python
# placeholder_list.py

# Create a string of placeholder characters, with one ? character
# per element in an array of values.

import string # needed for join method

# Array of values

values = [1, 2, 3, 4, 5]

# Method 1: use * to "multiply" and array and join to put commas between
# elements. Note that join requires a list of _strings_.

#@ _JOIN_METHOD_
str = ",".join(["?"] * len(values))
#@ _JOIN_METHOD_

print "Method 1:", str

#@ _CONCAT_METHOD_
str = ""
if len (values) > 0:
  str = "?"
for i in range (1, len (values)):
  str = str + ",?"
#@ _CONCAT_METHOD_

print "Method 2:", str
