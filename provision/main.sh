#!/bin/sh

# このファイルで使用する変数をまとめてあります・
# work_directoryは、Vagrantfileのsynced_folderで指定したフォルダと合わせてください。
ip_address=192.168.10.10
domain_name=local.vm
myapp_hosts="${ip_address} ${domain_name}"
mysql_root_password=Root@000


echo ------------------------------------------------------------
echo utils
echo ------------------------------------------------------------
sudo yum update -y
sudo yum install -y zip \
                    unzip \
                    wget \
                    vim \
                    git \
                    yum-utils

sudo timedatectl set-timezone Asia/Tokyo

sudo setenforce 0
sudo cat <<-CONF > /etc/selinux/config
SELINUX=disabled
SELINUXTYPE=targeted
CONF


echo --------------------------------------------------------------------------------
echo middleware - web server
echo --------------------------------------------------------------------------------

sudo yum install -y httpd
sudo usermod vagrant apache

sudo systemctl start httpd.service
sudo systemctl enable httpd.service


echo --------------------------------------------------------------------------------
echo middleware - database server
echo --------------------------------------------------------------------------------

sudo yum localinstall -y https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
  
sudo yum update -y
sudo yum --enablerepo=mysql80-community install -y mysql-community-server

sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service

sudo cat <<-CONF >> /etc/my.cnf
[mysqld]
default-authentication-plugin=mysql_native_password

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

character-set-server=utf8mb4
default_password_lifetime=0
CONF

sudo systemctl restart mysqld.service


password=`cat /var/log/mysqld.log | grep "A temporary password" | tr ' ' '\n' | tail -n1`
echo ${password}

mysql_secure_installation <<-ARG
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
ARG


echo --------------------------------------------------------------------------------
echo sdk
echo --------------------------------------------------------------------------------



echo --------------------------------------------------------------------------------
echo after
echo --------------------------------------------------------------------------------

echo --- SELinux ---
echo $ sudo getenforce
sudo getenforce

echo --- Web server ---
echo $ sudo systemctl status httpd.service
sudo systemctl status httpd.service

echo --- DB server ---
echo $ sudo systemctl status mysqld.service
sudo systemctl status mysqld.service

echo --- Runtime version ---

echo ================================================================================
