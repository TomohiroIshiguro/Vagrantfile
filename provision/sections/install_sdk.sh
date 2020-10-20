#!/bin/bash

# If you don't choose php, could you remove this area.

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

sudo cat <<-PHP_INI >> /etc/php.ini
error_logs = /var/log/php_errors.log

date.timezone = "Asia/Tokyo"
mbstring.language = Japanese
mbstring.internal_encoding = UTF-8

memory_limit=1024M
upload_max_filesize=512M
post_max_size=1024M
PHP_INI

# Install composer
# ----------------------------------------
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"