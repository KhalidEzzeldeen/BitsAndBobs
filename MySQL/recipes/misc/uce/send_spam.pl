#!/usr/bin/perl
# send_spam.pl - send junk mail to people listed in victim table

# 2000-12-08
# - Revised to use Mail::Sendmail rather than using sendmail directly.

use strict;
use warnings;
use Mail::Sendmail;
use Cookbook;

# Text of the subject header and template for message body.

my $subject = "Important Junk Mail just for you!";
my $template = <<TEMPLATE;
Dear %#salutation#% %#last_name#%,

This message is being sent to you because we know you'll be interested
in this special offer. Not everyone qualifies for this wonderful
opportunity, etc., etc., and we're certain you'll want to take
advantage of it immediately! For more details, visit our web site:
http://www.stupendous-offer-for-select-customers-only.com/
TEMPLATE

# SMTP host; change as necessary

my $smtp_host = "localhost";

# Hash containing arguments for sendmail. The To and Message
# values are set per-message. The From address is the current
# user.  The Subject is defined above.

my $login = getpwuid ($>) or die "Cannot determine username\n";
my %mail = (
    From => "$login\@localhost",
    Subject => $subject
);

my $dbh = Cookbook::connect ();

my $sth = $dbh->prepare ("SELECT * FROM victim");
$sth->execute ();
while (my $ref = $sth->fetchrow_hashref ())
{
  # For each column name, look for markers matching that name in
  # the template and replace them with the column value.  Markers
  # are of the form %#xxx#% for column xxx.
  # Use a copy of the template to avoid changing the original.

  my $tmpl = $template;
  foreach my $key (keys (%{$ref}))
  {
    $tmpl =~ s/%#$key+#%/$ref->{$key}/g;
  }
  $mail{To} = $ref->{email};
  $mail{Message} = $tmpl;
  sendmail (%mail) or die "sendmail failure sending to $ref->{email}\n";
}
$dbh->disconnect ();
