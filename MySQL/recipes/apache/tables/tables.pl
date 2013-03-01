#!/usr/bin/perl
# tables.pl - generate HTML tables

use strict;
use warnings;
use CGI qw(:standard escapeHTML);
use Cookbook;

my $title = "Query Output Display - Tables";

print header (), start_html (-title => $title, -bgcolor => "white");

my $dbh = Cookbook::connect ();

{ # begin scope

print p ("HTML table:");

# _PRINT_CD_TABLE_
my $sth = $dbh->prepare ("SELECT year, artist, title
                          FROM cd ORDER BY artist, year");
$sth->execute ();
my @rows = ();
push (@rows, Tr (th ("Year"), th ("Artist"), th ("Title")));
while (my ($year, $artist, $title) = $sth->fetchrow_array ())
{
  push (@rows, Tr (
                td (escapeHTML ($year)),
                td (escapeHTML ($artist)),
                td (escapeHTML ($title))
            ));
}
print table ({-border => "1"}, @rows);
# _PRINT_CD_TABLE_

} # end scope

{ # begin scope

print p ("HTML table with rows in alternating colors:");

# _PRINT_COLORED_CD_TABLE_
my $sth = $dbh->prepare ("SELECT year, artist, title
                          FROM cd ORDER BY artist, year");
$sth->execute ();
my $bgcolor = "silver";   # row-color variable
my @rows = ();
push (@rows, Tr (
              th ({-bgcolor => $bgcolor}, "Year"),
              th ({-bgcolor => $bgcolor}, "Artist"),
              th ({-bgcolor => $bgcolor}, "Title")
            ));
while (my ($year, $artist, $title) = $sth->fetchrow_array ())
{
  # toggle the row-color variable
  $bgcolor = ($bgcolor eq "silver" ? "white" : "silver");
  push (@rows, Tr (
                td ({-bgcolor => $bgcolor}, escapeHTML ($year)),
                td ({-bgcolor => $bgcolor}, escapeHTML ($artist)),
                td ({-bgcolor => $bgcolor}, escapeHTML ($title))
          ));
}
print table ({-border => "1"}, @rows);
# _PRINT_COLORED_CD_TABLE_

} # end scope

{ # begin scope

# _DISPLAY_CD_TABLE_1_
my $tbl_str = make_table_from_query (
                $dbh,
                "SELECT
                   year AS Year, artist AS Artist, title AS Title
                 FROM cd
                 ORDER BY artist, year"
              );
print $tbl_str;
# _DISPLAY_CD_TABLE_1_

} # end scope

{ # begin scope

# _DISPLAY_CD_TABLE_2_
my $tbl_str = make_table_from_query (
                $dbh,
                "SELECT
                   year AS Year, artist AS Artist, title AS Title
                 FROM cd
                 WHERE year < ?
                 ORDER BY artist, year",
                1990
              );
print $tbl_str;
# _DISPLAY_CD_TABLE_2_

} # end scope

{ # begin scope

# Note: Do NOT convert this to an equivalent SELECT from INFORMATION_SCHEMA
# statement!
#
# _DISPLAY_CHECK_TABLE_
print p("Result of CHECK TABLE operation:");
my $tbl_str = make_table_from_query ($dbh, "CHECK TABLE profile");
print $tbl_str;
# _DISPLAY_CHECK_TABLE_

} # end scope

$dbh->disconnect ();

print end_html ();
exit (0);

# _MAKE_TABLE_FROM_QUERY_
sub make_table_from_query
{
# db handle, query string, parameters to be bound to placeholders (if any)
my ($dbh, $stmt, @param) = @_;

  my $sth = $dbh->prepare ($stmt);
  $sth->execute (@param);
  my @rows = ();
  # use column names for cells in the header row
  push (@rows, Tr (th ([ map { escapeHTML ($_) } @{$sth->{NAME}} ])));
  # fetch each data row
  while (my $row_ref = $sth->fetchrow_arrayref ())
  {
    # encode cell values, avoiding warnings for undefined
    # values and using &nbsp; for empty cells
    my @val = map {
                defined ($_) && $_ !~ /^\s*$/ ? escapeHTML ($_) : "&nbsp;"
              } @{$row_ref};
    my $row_str;
    for (my $i = 0; $i < @val; $i++)
    {
      # right-justify numeric columns
      if ($sth->{mysql_is_num}->[$i])
      {
        $row_str .= td ({-align => "right"}, $val[$i]);
      }
      else
      {
        $row_str .= td ($val[$i]);
      }
    }
    push (@rows, Tr ($row_str));
  }
  return (table ({-border => "1"}, @rows));
}
# _MAKE_TABLE_FROM_QUERY_
