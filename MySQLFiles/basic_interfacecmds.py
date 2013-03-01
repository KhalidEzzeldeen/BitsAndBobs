import sys
import MySQLdb as ms
import connect

conn = connect(db, passwd)

# method 1: fetch row-by-row
cursor = conn.cursor()
cursor.execute("SELECT id, name, cats FROM profile")
while 1:
    row = cursor.fetchone()
    if row == None:
	break
    print "id: %s, name: %s, cats: %s" % \
          (row[0], row[1], row[2])
print "Number of rows returned: %d" % cursor.rowcount
cursor.close()

# method 2: all rows at once
cursor = conn.cursor()
cursor.execute("SELECT id, name, cats FROM profile")
rows = cursor.fetchall()
for row in rows:
    print "id: %s, name: %s, cats: %s" % \
          (row[0], row[1], row[2])
print "Number of rows returned: %d" % cursor.rowcount
cursor.close()

# method 3: cursor as dictionary
cursor = conn.cursor(ms.cursors.DictCursor)
cursor.execute("SELECT id, name, cats FROM profile")
rows = cursor.fetchall()
for row in rows:
    print "id: %s, name: %s, cats: %s" % \
          (row["id"], row["name"], row["cats"])
print "Number of rows returned: %d" % cursor.rowcount
cursor.close()

# inserting Null values; lets interface automagically handle stuff
# note that "None" is converted to "NULL" by the handler...
cursor = conn.cursor()
cursor.execute('''
               INSERT INTO profile (name,birth,color,foods,cats)
               VALUES(%s,%s,%s,%s,%s)
               ''', ("De'Mont", "1973-01-12", None, "eggroll", 4))
# can also do "conn.literal(data) for every field

# testing for NULL values; pretty simple:
# not really needed; Pythong knows it's None..
cursor = conn.cursor()
cursor.execute("SELECT name, birth, foods FROM profile")
for row in cursor.fetchall():
    row = list(row)         # bc shit comes in tuples, yo
    for i,e in enumerate(row):
        if not e:   # is this shit empty?
            row[i] = "NULL"
    '''do stuff w/ row'''
cursor.close()

# fun stuff like this...
conn = connect.handcon(db='cookbook',p='5ucky*ma')
cursor = conn.cursor()
keep = []
for i in range(1,67):
	cursor.execute('''SELECT COUNT(*) FROM kjv
                          WHERE MATCH(vtext) AGAINST('Satan') AND bnum<=%d'''\
                       % (i))
	data = list(cursor.fetchall())
	keep.append(int(list(data[0])[0]))


