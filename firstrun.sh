#!/bin/bash

# If databases do not exist create them
if [ -f /db/mysql/user.MYD ]; then
  echo "database exists"
else
  /usr/bin/mysql_install_db --datadir=/db
fi
