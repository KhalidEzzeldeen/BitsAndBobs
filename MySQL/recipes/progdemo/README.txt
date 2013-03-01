This directory contains demonstration programs that go along with the
instructions in Appendix B that illustrate how to run programs from
the command line.

perldemo.pl, rubydemo.pl, phpdemo.php,and pythondemo.py have no
shebang (#!) line that names the appropriate language processor,
and they do not have the +x access mode enabled.  You need to execute
them as an argument to the language processor:

perl perldemo.pl
ruby rubydemo.rb
php phpdemo.php
python pythondemo.py

perldemo2.pl, rubydemo2.pl, and pythondemo2.py have a shebang line
and (on Unix) have the +x access mode enabled. On Unix, you should be able
to execute them directly like this:

./perldemo2.pl
./rubydemo2.rb
./pythondemo2.py

On Windows, if you have filename associations set up for Python, Ruby, and
Python, you should be able to execute them directly like this:

perldemo2.pl
rubydemo2.rb
pythondemo2.py
