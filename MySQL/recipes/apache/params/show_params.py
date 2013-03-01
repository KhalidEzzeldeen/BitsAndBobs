#!/usr/bin/python
# show_params.py - print request parameter names and values

import sys
import os
import types
import cgi
from Cookbook_Webutils import make_unordered_list

title = "Script Input Parameters"

# Print content type header and blank line that separates
# headers from page body

print "Content-Type: text/html"
print ""
print "<html>"
print "<head>"
print "<title>" + title + "</title>"
print "</head>"
print "<body bgcolor=\"white\">"

print "<p>Parameters from cgi.FieldStorage():</p>"

#@ _DISPLAY_PARAMS_
#@ _GET_PARAM_NAMES_
params = cgi.FieldStorage ()
param_names = params.keys ()
#@ _GET_PARAM_NAMES_
param_names.sort ()
print "<p>Parameter names:", param_names, "</p>"
items = []
for name in param_names:
  if type (params[name]) is not types.ListType:  # it's a scalar
    ptype = "scalar"
    val = params[name].value
  else:                                         # it's a list
    ptype = "list"
    val = []
    for item in params[name]:   # iterate through MiniFieldStorage
      val.append (item.value)   # items to get item values
    val = ",".join (val)        # convert to string for printing
  items.append ("type=" + ptype + ", name=" + name + ", value=" + val)
print make_unordered_list (items)
#@ _DISPLAY_PARAMS_

print "<p>Parameters from cgi.parse_qs():</p>"

try:
  params = cgi.parse_qs (os.environ["QUERY_STRING"])
except:
  params = { }
param_names = params.keys ()
param_names.sort ()
print "<p>Parameter names:", param_names, "</p>"
items = []
for name in param_names:      # all items are returned as lists
  val = []
  for item in params[name]:    # iterate through items to get values
    val.append (item)
  val = ",".join (val)        # convert to string for printing
  items.append ("name=" + name + ", value=" + val)
print make_unordered_list (items)

# include forms that can be sent via get or post

# If script is run from the command line, SCRIPT_NAME won't exist; fake
# it by using script name.

if not os.environ.has_key ("SCRIPT_NAME"):
  os.environ["SCRIPT_NAME"] = sys.argv[0]

print """
<p>Form 1:</p>

<form method="get" action="%s">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by get">
</form>

<p>Form 2:</p>

<form method="post" action="%s">
Enter a text value:
<input type="text" name="text_field" size="60">
<br />

Select any combination of colors:<br />
<select name="color" multiple="multiple">
<option value="red">red</option>
<option value="white">white</option>
<option value="blue">blue</option>
<option value="black">black</option>
<option value="silver">silver</option>
</select>
<br />

<input type="submit" name="choice" value="Submit by post">
</form>
""" % (os.environ["SCRIPT_NAME"], os.environ["SCRIPT_NAME"])

print "</body>"
print "</html>"
