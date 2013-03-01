#!/bin/sh
# mysql_uptime2.sh - report server uptime

mysql -e STATUS | grep "^Uptime"
