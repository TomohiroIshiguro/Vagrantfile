#!/bin/bash

# ----------------------------------------
# Change root password
# ----------------------------------------

password=`cat /var/log/mysqld.log | grep "A temporary password" | tr ' ' '\n' | tail -n1`
echo ${password}

mysql_secure_installation <<-ARGS
${password}
${mysql_root_password}
${mysql_root_password}
y
${mysql_root_password}
${mysql_root_password}
y
n
y
y
y
ARGS

# ----------------------------------------
# Create a database
# ----------------------------------------

mysql -uroot --password=${mysql_root_password} --connect-expired-password < /vagrant/deploy/database/init_database.sql