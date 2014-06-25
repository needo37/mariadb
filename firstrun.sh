#!/bin/bash

# If databases do not exist create them
if [ -f /db/mysql/user.MYD ]; then
  echo "database exists"
else
  /usr/bin/mysql_install_db --datadir=/db
  mysql -u root -e \
      "GRANT ALL PRIVILEGES ON *.* TO 'root'@'*';"
  mysqladmin -u root shutdown
fi
