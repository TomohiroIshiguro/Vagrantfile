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
sudo usermod -aG vagrant apache

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

sudo yum localinstall -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum localinstall -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum install -y yum-utils
sudo yum-config-manager --enable remi-php74

sudo yum update -y
sudo yum install -y php \
                    php-bcmath \
                    php-cli \
                    php-ctype \
                    php-devel \
                    php-json \
                    php-mbstring \
                    php-mysql \
                    php-tokenizer \
                    php-xml \
                    php-pdo

sudo cat <<-CONF >> /etc/php.ini
error_logs = /var/log/php_erros.log

date.timezone = "Asia/Tokyo"
mbstring.language = Japanese
mbstring.internal_encoding = UTF-8
CONF


sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"


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
echo $ php --version
php --version

echo ================================================================================
