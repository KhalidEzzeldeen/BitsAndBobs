#!/usr/bin/python
# hexdump.py - hex dump

# Usage: hexdump.py [ filename ] ...

import sys

def hexdump (f):
  pos = 0
  map = \
    '........... ....' \
    '................' \
    ' !"#$%&\'()*+,-./' \
    '0123456789:;<=>?' \
    '@ABCDEFGHIJKLMNO' \
    'PQRSTUVWXYZ[\]^_' \
    '`abcdefghijklmno' \
    'pqrstuvwxyz{|}~.' \
    '................' \
    '................' \
    '................' \
    '................' \
    '................' \
    '................' \
    '................' \
    '................'
  while 1:
    buf = f.read (16)
    length = len (buf)
    if length == 0:
      return
    hex = ""
    asc = ""
    for i in range (0, length):
      c = buf[i]
      if i == 8:
        hex = hex + " "
      hex = hex + ("%02x " % ord (c))
      asc = asc + map[ord (c)]
    print "%05x: %-48s %s" % (pos, hex, asc)
    pos = pos + 16


# Read stdin if no files were named, otherwise read each named file

if len (sys.argv) < 2:
  hexdump (sys.stdin)
else:
  for name in sys.argv[1:]:
    f = open (name, "r")
    hexdump (f)
    f.close ()
