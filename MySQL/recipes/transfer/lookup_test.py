#!/usr/bin/python
# lookup_test.py - demonstrate use of dictionary for lookup/validation purposes

# create dictionary, add members to it, using values as keys

members = { }
members["pig"] = 1;
members["cat"] = 1;
members["duck"] = 1;
members["dog"] = 1;

# show list of legal values

print "Legal values:",
for key in members.keys():
  print key,
print

# test some values to see whether they're in the dictionary

print "Test some values:"
for val in ("cat", "snake"):
  if members.has_key (val):
    print val + " (good)"
  else:
    print val + " (bad)"
