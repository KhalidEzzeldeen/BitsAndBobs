MySQL Cookbook (second edition) recipes Distribution
Paul DuBois, paul@kitebird.com

This is the recipes distribution that accompanies MySQL Cookbook,
second edition (O'Reilly Media, (c) 2007).  The latest version of
the distribution and the errata list for the book are available at:

  http://www.kitebird.com/mysql-cookbook/

If you find that files appear to be missing from this distribution,
please let me know.

If you are using a database name other than "cookbook", substitute that
name wherever you see cookbook in the distribution files.

If you were using scripts from the first edition of MySQL Cookbook
and now have "upgraded" to the second edition, there are some
important notes you should read at the end of this file.

Directories in this distribution:

tables
  SQL scripts for creating tables used in the book
mysql
  Using the mysql client program (chapter 1)
api
  MySQL programming; API basics (chapter 2)
lib
  Library files use by lots of programs (chapter 2, other later chapters)
select
  Record selection techniques (chapter 3)
tblmgmt
  Table management scripts (chapter 4)
strings
  Using strings (chapter 5)
dates
  Date and time manipulation (chapter 6)
sorting
  Sorting operations (chapter 7)
summary
  Summary operations (chapter 8)
metadata
  Using metadata (chapter 9)
transfer
  Data import/export (chapter 10)
sequences
  Using sequences (chapter 11)
joins
  Multi-table joins (chapter 12)
union
  UNION operations (chapter 12)
stats
  Statistical techniques (chapter 13)
dups
  Duplicate processing (chapter 14)
transactions
  Performing transactions (chapter 15)
routines, triggers, events
    Using Stored Routines, Triggers, and Events (chapter 16
apache
  Web programming using Apache (Perl, PHP, Python, chapters 17-19)
tomcat
  Web programming using Tomcat (Java/JSP, chapters 17-19)
progdemo
  Executing Programs from the Command Line (appendix B)
misc
  Miscellaneous stuff

Other files:

setCLASSPATH
  Example tcsh/csh script for setting CLASSPATH (to use it, execute
  this command: source setCLASSPATH)

To install a script or program for general use, put it in a directory
that is listed in your PATH setting.  (PATH settings are discussed
in chapter 1.)  For example, under Unix, you might put a script in
/usr/local/bin, or in the bin directory under your home directory.

Web scripts should be installed according to the instructions given
in the book.

Files often contain lines with "#@ _IDENTIFIER_" sequences.  These
are just placemarkers, used to block out sections that are used for
examples in the book, and may be ignored.

You'll note that many of the Perl scripts include lines that look like this:

{ # begin scope
} # end scope

Their purpose is to allow similar examples within the same file that
use the same variables all to declare the variables with "my".  By
introducing a new scope for each example, the declarations don't trigger
warnings from Perl.

----------------------------------------------------------------------
Some important differences between the recipes distributions for the
first and second editions:

Note 1:

Scripts for the first edition typically included a line that added
a library directory to the script's language processor search path.
For example, Perl scripts included this line:

use lib qw(/usr/local/apache/lib/perl);

That directory was assumed to contain any library Cookbook-related
Perl library files.

For the second edition, scripts do not include these lines.  Instead,
you should set your environment to name the relevant directories.
Suppose that you put the library files in /usr/local/lib/mcb.  Then
for tcsh, you might set the environment like this:

setenv PERLLIB /usr/local/lib/mcb
setenv RUBYLIB /usr/local/lib/mcb
setenv PYTHONPATH /usr/local/lib/mcb

For Bourne shells:

export PERLLIB=/usr/local/lib/mcb
export RUBYLIB=/usr/local/lib/mcb
export PYTHONPATH=/usr/local/lib/mcb

For PHP, modify your system's php.ini to include the directory where
you install PHP library files.  (Set the value of the include_path
directive.)

For Java, set the CLASSPATH environment variable.

Note 2:

If you have the first edition of MySQL Cookbook, be warned
that the PHP library files in the second edition have the
same names as in the first edition, but are incompatible
with them.  If you are using any PHP scripts that depend on
the first edition library files, they will break if you
install the second edition library files on top of them.  To
prevent this from happening, use the following procedure:

1. Change location into the directory where you installed
   the first edition library files and make a copy of each
   one:

        % cp Cookbook.php Cookbook1.php
        % cp Cookbook_Utils.php Cookbook_Utils1.php
        % cp Cookbook_Webutils.php Cookbook_Webutils1.php
        % cp Cookbook_Session.php Cookbook_Session1.php

2. Find all PHP scripts that include the first edition
   library files, and change them to include the *1.php
   files instead.  For example, a script that includes Cook-
   book_Utils.php should be changed to include Cook-
   book_Utils1.php.  (Some of the library files themselves
   include other library files, so you'll also need to edit
   the *1.php files.)

3. Test the modified scripts to make sure that they work
   correctly with the *1.php files.

Now you can install the second edition library files on top
of the first edition files that have the same names.  PHP
scripts from the second edition will use these new library
files, and old scripts should continue to work correctly.
----------------------------------------------------------------------
