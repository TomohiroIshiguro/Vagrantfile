#!/bin/bash

cd ${work_directory}



# ----------------------------------------
# Set web server config
# ----------------------------------------

#sudo cat <<-VHOST >> /etc/httpd/conf.d/vhost.conf
#User vagrant
#Group vagrant
#
#<VirtualHost *:80>
#  ServerName ${ip_address}
#  DocumentRoot ${work_directory}/${app_folder}/public
#  <Directory ${work_directory}/${app_folder}/public>
#    Options FollowSymLinks
#    AllowOverride ALL
#    Require all granted
#  </Directory>
#</VirtualHost>
#
#<VirtualHost *:80>
#  ServerName ${domain_name}
#  DocumentRoot ${work_directory}/${app_folder}/public
#  <Directory ${work_directory}/${app_folder}/public>
#    Options FollowSymLinks
#    AllowOverride ALL
#    Require all granted
#  </Directory>
#</VirtualHost>
#VHOST
#sudo systemctl restart httpd.service
