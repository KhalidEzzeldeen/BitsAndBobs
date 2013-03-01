This directory contains files related to writing JSP pages that use MySQL,
running under Tomcat.


mcb.war
    WAR file containing the files for the mcb sample application.
    Copy it to Tomcat's webapps directory and restart Tomcat, which
    should unpack it automatically.  Note that this, in itself, will
    not allow pages that use the JDBC driver or JSTL tags to work.
    It's necessary to install the MySQL Connector/J driver, and to
    install JSTL (and enable the JSTL entries in the mcb/WEB-INF/web.xml
    file).  This process is described in chapter 16 of the Cookbook.

mcb
    The directory from which mcb.war is created.  After Tomcat unpacks
    mcb.war, there will be an identical hierarchy under Tomcat's webapps
    directory.  The hierarchy looks like this:
    mcb/               application context root directory
        WEB-INF/       application's private directory
           web.xml     web application deployment descriptor file
           lib/        directory for application-specific JAR files
           classes/    directory for application-specific class files

The classes directory contains two example servlets.  If you compile the
versions located under webapps/mcb, you'll create .class files that can
be invoked like this (adjust hostname and port number appropriately):

    http://localhost:8080/mcb/servlet/SimpleServlet
    http://localhost:8080/mcb/servlet/GetOrPostServlet

NOTE: As of Tomcat 4.1.12, the invoker servlet required for those
servlets is disabled by default.  The mcb/WEB-INF/web.xml file contains
a <servlet-mapping> element that enables the invoker for the mcb context
so that SimpleServlet and GetOrPostServlet will work.

Note that the Tomcat docs now discourage use of the invoker servlet
in a production environment.  You can comment out the <servlet-mapping>
element to disable it.


makewar.sh
    Shell script to generate mcb.war from the mcb directory.
   
README.JDBC.Realm
	Instructions for using MySQL to store Tomcat usernames, passwords,
	and roles.  (This replaces Tomcat's tomcat-users.xml file with a
	MySQL-based storage mechanism).
   
README.JDBC.Session
	Instructions for using MySQL to store session information.
	(This replaces Tomcat's default session mechanism).
