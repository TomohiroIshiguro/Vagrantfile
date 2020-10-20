#!/bin/bash

cd ${work_directory}

# In case to create a new project
# ----------------------------------------
/usr/local/bin/composer create-project --prefer-dist laravel/laravel=5.8 ${app_folder}
cd ${app_folder}

# In case to clone an existing project
# ----------------------------------------
# git clone ${target_branch} ${repository_url} ${app_folder} <<-AGREE
# yes
# AGREE
# cd ${app_folder}
# /usr/local/bin/composer install

sudo chmod -R 777 ./bootstrap/cache
sudo chmod -R 777 ./storage

sudo cp /vagrant/deploy/config/.env .

php artisan key:generate

# ----------------------------------------
# Create Database tables
# ----------------------------------------

php artisan migrate --seed

# ----------------------------------------
# Set web server config
# ----------------------------------------

sudo cat <<-VHOST >> /etc/httpd/conf.d/vhost.conf
User vagrant
Group vagrant

<VirtualHost *:80>
  ServerName ${ip_address}
  DocumentRoot ${work_directory}/${app_folder}/public
  <Directory ${work_directory}/${app_folder}/public>
    Options FollowSymLinks
    AllowOverride ALL
    Require all granted
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName ${domain_name}
  DocumentRoot ${work_directory}/${app_folder}/public
  <Directory ${work_directory}/${app_folder}/public>
    Options FollowSymLinks
    AllowOverride ALL
    Require all granted
  </Directory>
</VirtualHost>
VHOST
sudo systemctl restart httpd.service