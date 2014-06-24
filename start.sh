#!/bin/bash

# If databases do not exist create them
if [ -f /db/mysql/user.MYD ]; then
  continue
else
  /usr/bin/mysql_install_db --datadir=/db
fi

# Start the daemon
/usr/bin/mysqld_safe --datadir='/db'
