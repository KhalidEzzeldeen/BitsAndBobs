#!/usr/bin/perl
# survey.pl - show how to present a simple survey

# The questions and possible choices are stored in the database.
# The script illustrates:
# - how to display multiple choice questions using database content
# - how to verify the responses against the database to make sure they're
#   legal
# - how to store the responses

use strict;
use warnings;
use CGI qw(:standard escape escapeHTML);
use Cookbook;

my $title = "Survey Example";

my $page = header (), start_html (-title => $title, -bgcolor => "white");

my $dbh = Cookbook::connect ();

# If no choice parameter is present, display survey form.
# Otherwise, check the results and record them.

if (!defined (param ("choice")))
{
  $page .= make_survey_form ($dbh);
}
else
{
  $page .= record_survey_response ($dbh);
}

$dbh->disconnect ();

$page .= end_html ();

print $page;

exit (0);

# ----------------------------------------------------------------------

# Pull out the ID and text for each survey question.  The ID values are
# used as the names for the fields in the form, using the format "q_nn",
# where nn is the ID number.  That way they can be distinguished easily
# from other fields the form might include.

# The algorithm for generating the radio button sets is inefficient,
# but easier to understand than a more efficient method.  It'd be better
# to fetch all the choices in a single query and associate each record
# with a button set index by question ID.

sub make_survey_form
{
my $dbh = shift;

  my $form = start_form (-action => url ());

  my $q_ref = $dbh->selectall_arrayref (
                "SELECT q_id, q_text FROM survey_question");
  foreach my $row_ref (@{$q_ref})
  {
    my ($q_id, $q_text) = @{$row_ref};
    my @values = ();
    my %labels = ();
    # retrieve choices for each question
    my $sth = $dbh->prepare (
                "SELECT c_id, c_text FROM survey_choice
                 WHERE q_id = ? ORDER BY c_id");
    $sth->execute ($q_id);
    while (my ($c_id, $c_text) = $sth->fetchrow_array ())
    {
      push (@values, $c_id);
      $labels{$c_id} = $c_text;
    }
    # add question and choices to form
    $form .= p (escapeHTML ($q_text))
           . radio_group (-name => "q_$q_id",
                          -values => \@values,
                          -labels => \%labels,
                          -linebreak => 1);

  $form .= br ()
         . submit (-name => "choice", -value => "Submit")
         . end_form ();
  return ($form);
}

# Check the responses.  If any are bad, squawk.  Otherwise, record
# them in the survey_response table.

# As with make_survey_form(), the algorithm is simple but not as
# efficient as it might be.

sub record_survey_response
{
my $dbh = shift;
my %responses;
my @errors;
my $result;

  # get names of parameters that correspond to question IDs,
  # then check parameter value for each one against possible values
  # listed in database.
  my @param_names = grep (/^q_/, param ());
  foreach my $q_id (@param_names)
  {
    my $c_id = param ($q_id); # parameter value (corresponds to c_id)
    $q_id =~ s/^q_//;     # q_id value
    # this query returns 1 if there is a matching item, 0 if not
    my $ok = $dbh->selectrow_array (
                    "SELECT COUNT(*) FROM survey_choice
                     WHERE q_id = ? AND c_id = ?",
                      undef, $q_id, $c_id);
    if ($ok)
    {
      $responses{$q_id} = $c_id;
    }
    else
    {
      push (@errors, "Bad response for question $q_id!");
    }
  }
  if (@errors)      # Someone's trying to hack us! :-)
  {
    $result .= p ("Some responses were not valid:")
             . ul (li (\@errors));
    }
    else          # store the responses
  {
    # this code stores the responses two ways:
    # - increment the c_tally count for the survey_choice table item
    # - add a record to the survey_response table
    foreach my $q_id (keys (%responses))
    {
      my $c_id = $responses{$q_id};
      $dbh->do ("UPDATE survey_choice
                 SET c_tally = c_tally+1
                 WHERE q_id = ? AND c_id = ?",
                undef, $q_id, $c_id);
      $dbh->do ("INSERT INTO survey_response (q_id, c_id) VALUES(?,?)",
                undef, $q_id, $c_id);
    }
    $result .= p ("Survey response entered.  Thanks.");
  }

  return ($result);
}
