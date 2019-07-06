#!/bin/sh

# このファイルで使用する変数をまとめてあります・
# work_directoryは、Vagrantfileのsynced_folderで指定したフォルダと合わせてください。
ip_address=192.168.33.84
domain_name=vm.local
myapp_hosts="${ip_address} ${domain_name}"
mysql_root_password=Root-000


echo --------------------------------------------------------------------------------
echo before
echo --------------------------------------------------------------------------------

sudo yum update -y
sudo yum install -y zip unzip vim git wget yum-utils


echo --------------------------------------------------------------------------------
echo os setting
echo --------------------------------------------------------------------------------

sudo timedatectl set-timezone Asia/Tokyo

sudo cat <<-HOSTS >> /etc/hosts
${myapp_hosts}
HOSTS


echo --------------------------------------------------------------------------------
echo disable SELinux
echo --------------------------------------------------------------------------------

sudo setenforce 0
sudo cat <<-CONF > /etc/selinux/config
SELINUX=disabled
SELINUXTYPE=targeted
CONF


echo --------------------------------------------------------------------------------
echo install Apache
echo --------------------------------------------------------------------------------

sudo yum install -y httpd
sudo usermod vagrant apache

sudo systemctl start httpd.service
sudo systemctl enable httpd.service


echo --------------------------------------------------------------------------------
echo install MySQL
echo --------------------------------------------------------------------------------

sudo yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
sudo yum install -y mysql-community-server


sudo cat <<-CONF >> /etc/my.cnf
default_authentication_plugin=mysql_native_password

# innodb_file_per_table=1
# early-plugin-load=keyring_file.so
# keyring_file_data=/var/lib/mysql-keyring/keyring

# innodb_doublewrite=0
# innodb_undo_directory=/var/lib/mysql-undo
# innodb_rollback_segments=35
# innodb_redo_log_encrypt=1
# innodb_undo_log_encrypt=1
CONF

# テーブルごとに暗号化を行う場合
# mkdir -p /usr/local/mysql/mysql-keyring
# chown -R mysql.mysql /usr/local/mysql
# chmod 750 /usr/local/mysql/mysql-keyring
# mkdir /var/lib/mysql-undo
# chown mysql.mysql /var/lib/mysql-undo

sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service


# rootユーザのパスワードを取得する
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
echo install PHP
echo --------------------------------------------------------------------------------

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72

sudo yum install -y php php-mcrypt php-mbstring php-pdo php-mysql php-gd php-xml php-pear php-devel php-intl php-cli php-tokenizer php-json

sudo cat <<-CONF >> /etc/php.ini
# コメントアウトを解除
error_logs = /var/log/php_erros.log

# それぞれ値を変更
date.timezone = "Asia/Tokyo"
mbstring.language = Japanese
mbstring.internal_encoding = UTF-8
CONF


echo --------------------------------------------------------------------------------
echo install Composer
echo --------------------------------------------------------------------------------

sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


echo --------------------------------------------------------------------------------
echo after
echo --------------------------------------------------------------------------------

echo $ sudo cat /etc/hosts
sudo cat /etc/hosts

echo --- SELinux ---
echo $ sudo getenforce
sudo getenforce

echo --- Web server ---
echo $ sudo systemctl status httpd.service
sudo systemctl status httpd.service

echo --- DB server ---
echo $ sudo systemctl status mysqld.service
sudo systemctl status mysqld.service

echo --- Exec Runtime ---
echo $ php --version
php --version

echo ================================================================================
