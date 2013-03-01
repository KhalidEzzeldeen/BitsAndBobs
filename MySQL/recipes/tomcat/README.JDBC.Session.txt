To tell Tomcat to store session information in MySQL, use the following
procedure:

- Create the tomcat_session table using the script in the
  tables/tomcat.sql file.
- Add a <Context> element to Tomcat's conf/server.xml file that
  looks like this:

<Context path="/mcb" docBase="mcb" debug="0" reloadable="true">
  <Manager
    className="org.apache.catalina.session.PersistentManager"
    debug="0"
    saveOnRestart="true"
    maxActiveSessions="-1"
    minIdleSwap="900"
    maxIdleSwap="1200"
    maxIdleBackup="600">
    <Store
      className="org.apache.catalina.session.JDBCStore"
      driverName="com.mysql.jdbc.Driver"
      connectionURL=
        "jdbc:mysql://localhost/cookbook?user=cbuser&amp;password=cbpass"
      sessionTable="tomcat_session"
      sessionIdCol="id"
      sessionAppCol="app"
      sessionDataCol="data"
      sessionValidCol="valid_session"
      sessionLastAccessedCol="last_access"
      sessionMaxInactiveCol="max_inactive"
    />
  </Manager>
</Context>

- Restart Tomcat.
