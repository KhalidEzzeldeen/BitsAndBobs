#!/bin/sh
# mysql_uptime.sh - report server uptime in seconds

mysql --skip-column-names -B -e "SHOW /*!50002 GLOBAL */ STATUS LIKE 'Uptime'"
