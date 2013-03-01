@ECHO OFF
REM mysql_uptime.bat - report server uptime in seconds

mysql --skip-column-names -B -e "SHOW /*!50002 GLOBAL */ STATUS LIKE 'Uptime'"
