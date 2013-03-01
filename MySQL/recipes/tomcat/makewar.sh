#!/bin/sh

(cd mcb/WEB-INF/classes;jikes SimpleServlet.java)
(cd mcb/WEB-INF/classes;jikes GetOrPostServlet.java)
rm -f ./mcb.war
cd mcb
# RedHat 7.0 jar is busted and generates bad WAR file with mcb/ in
# pathnames.
#jar cf ../mcb.war .
zip -r ../mcb.war .
