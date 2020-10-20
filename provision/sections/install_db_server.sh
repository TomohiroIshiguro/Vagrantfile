#!/bin/bash

# If you don't need database server in the server, could you remove this area.

sudo yum localinstall -y https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo

sudo yum update -y
sudo yum --enablerepo=mysql80-community install -y mysql-community-server

sudo systemctl start mysqld.service

sudo cat <<-DB_CONFIG > /etc/my.cnf
[mysqld]
default-authentication-plugin=mysql_native_password
validate_password.policy = "LOW"

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

character-set-server=utf8mb4
default_password_lifetime=0
DB_CONFIG

sudo systemctl restart mysqld.service
sudo systemctl enable mysqld.service