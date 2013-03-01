#!/usr/bin/perl
# to_excel.pl - read tab-delimited, linefeed-terminated input, write
# Excel-format output to the standard output.

use strict;
use warnings;
use Spreadsheet::WriteExcel::Simple;

my $ss = Spreadsheet::WriteExcel::Simple->new ();

while (<>)                            # read each row of input
{
  chomp;
  my @data = split (/\t/, $_, 10000); # split, preserving all fields
  $ss->write_row (\@data);            # write row to the spreadsheet
}

binmode (STDOUT);
print $ss->data (); # write the spreadsheet
