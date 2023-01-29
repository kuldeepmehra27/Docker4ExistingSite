#!/bin/bash

# SQL file path 
CWD="$(pwd)/drupal8.sql"

mysql -u $MYSQL_USER -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < ${CWD}

# Mysql commands 
#mysql -uroot -prootpass <<MYSQL_SCRIPT
#USE ${MAINDB};
#SOURCE ${CWD};
#MYSQL_SCRIPT

