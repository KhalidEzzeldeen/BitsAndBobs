#!/usr/bin/ruby -w
# get_ticket.rb - ticket-dispensing methods

# method 1 - simple but incorrect (dispenses ticket even if there are none)
# method 2 - dispense ticket using transaction
# method 3 - dispense ticket using atomic action rather than transaction

require "Cookbook"


# Create the example table and populate it with a few rows

def init_table(dbh)
  begin
    dbh.do("DROP TABLE IF EXISTS meeting")
    dbh.do("
          CREATE TABLE meeting
          (
            meeting_id  INT UNSIGNED NOT NULL,
            PRIMARY KEY (meeting_id),
            tix_left    INT UNSIGNED NOT NULL
          )
          ENGINE = INNODB")
    dbh.do("INSERT INTO meeting (meeting_id, tix_left) VALUES (53, 100)")
    dbh.do("INSERT INTO meeting (meeting_id, tix_left) VALUES (72, 50)")
    dbh.do("INSERT INTO meeting (meeting_id, tix_left) VALUES (91, 150)")
    dbh.do("INSERT INTO meeting (meeting_id, tix_left) VALUES (102, 0)")
  rescue DBI::DatabaseError => e
    puts "Cannot initialize test table"
    puts "#{e.err}: #{e.errstr}"
  end
end



def get_ticket1(dbh, meeting_id)
#@ _GET_TICKET_1_
  count = dbh.do("UPDATE meeting SET tix_left = tix_left-1
                  WHERE meeting_id = ?",
                 meeting_id)
  return count
end
#@ _GET_TICKET_1_


def get_ticket2(dbh, meeting_id)
#@ _GET_TICKET_2_
  count = 0
  begin
    dbh['AutoCommit'] = false
    # check the current ticket count
    row = dbh.select_one("SELECT tix_left FROM meeting
                          WHERE meeting_id = ?",
                         meeting_id)
    count = row[0]
    # if there are tickets left, decrement the count
    if count > 0
      dbh.do("UPDATE meeting SET tix_left = tix_left-1
              WHERE meeting_id = ?",
             meeting_id)
    end
    dbh.commit
    dbh['AutoCommit'] = true
  rescue DBI::DatabaseError => e
    count = 0       # if an error occurred, no tix available
    begin           # empty exception handler in case rollback fails
      dbh.rollback
      dbh['AutoCommit'] = true
    rescue
    end
  end

  return count > 0
end
#@ _GET_TICKET_2_


# Return true if the UPDATE changed a row, indicating that there
# were tickets left.

def get_ticket3(dbh, meeting_id)
#@ _GET_TICKET_3_
  count = dbh.do("UPDATE meeting SET tix_left = tix_left-1
                  WHERE meeting_id = ? AND tix_left > 0",
                 meeting_id)
  return count > 0
end
#@ _GET_TICKET_3_


dbh = Cookbook.connect

# Try to get tickets for an event that has some (53),
# and an event that has none (102)

init_table(dbh)
okay = get_ticket1(dbh, 53)
puts "Method 1: Ticket available for event 53: " + (okay ? "yes" : "no")
okay = get_ticket1(dbh, 102)
puts "Method 1: Ticket available for event 102: " + (okay ? "yes" : "no")

init_table(dbh)
okay = get_ticket2(dbh, 53)
puts "Method 2: Ticket available for event 53: " + (okay ? "yes" : "no")
okay = get_ticket2(dbh, 102)
puts "Method 2: Ticket available for event 102: " + (okay ? "yes" : "no")

init_table(dbh)
okay = get_ticket3(dbh, 53)
puts "Method 3: Ticket available for event 53: " + (okay ? "yes" : "no")
okay = get_ticket3(dbh, 102)
puts "Method 3: Ticket available for event 102: " + (okay ? "yes" : "no")

dbh.disconnect
