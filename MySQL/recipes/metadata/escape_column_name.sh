#!/bin/sh
# escape_column_name.sh

# show how to escape column names in various languages

echo "Perl"
perl <<'EOF'
use warnings;
my $name = "a_c";
print "$name\n";
#@ _PERL_
$name =~ s/([%_])/\\$1/g;
#@ _PERL_
print "$name\n";
EOF

echo "Ruby"
ruby -w <<'EOF'
name = "a_c"
puts name
#@ _RUBY_
name.gsub!(/([%_])/, '\\\\\1')
#@ _RUBY_
puts name
EOF

echo "PHP"
php <<'EOF'
<?php
$name = "a_c";
print "$name\n";
#@ _PHP_
$name = ereg_replace ("([%_])", "\\\\1", $name);
#@ _PHP_
print "$name\n";
?>
EOF

echo "Python"
python <<'EOF'
import re
name = "a_c"
print name
#@ _PYTHON_
name = re.sub (r'([%_])', r'\\\1', name)
#@ _PYTHON_
print name
EOF
