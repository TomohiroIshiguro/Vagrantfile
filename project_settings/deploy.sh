#!/bin/sh

gitlab_user=
gitlab_pass=

app_name=myapp
domain_name=local.vm
mysql_root_password=Root@000
work_directory=/var/www/project
clone_location=/var/www
branch='-b develop'
repository_url=https://${gitlab_user}:${gitlab_pass}@github.com/account/project.git



echo --------------------------------------------------------------------------------
echo deploy project
echo --------------------------------------------------------------------------------

mysql -u root --password=${mysql_root_password} --connect-expired-password < /vagrant/provision/database_init.sql

sudo chown -Rv root:$USER ${work_directory}
sudo chmod -Rv g+rw ${work_directory}

cd ${clone_location}
sudo git clone ${branch} ${repository_url}

cd ${work_directory}
sudo chmod 777 bootstrap/cache storage -R
sudo chmod 777 storage -R

sudo cat <<-CONF > ${work_directory}/${project_name}/.env
APP_NAME=${app_name}
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://${domain_name}/

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=myapp_db
DB_USERNAME=developer
DB_PASSWORD=Develop@000

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
CONF

/usr/local/bin/composer install
/usr/local/bin/composer update
php artisan generate:key
php artisan migrate --seed


sudo cat <<-VHOSTS >> /etc/httpd/conf.d/vhosts.conf
<VirtualHost *:80>
    DocumentRoot ${work_directory}/public
    ServerName ${domain_name}

    <Directory ${work_directory}/public>
        Options +FollowSymLinks
        AllowOverride all
    </Directory>
</VirtualHost>
VHOSTS
sudo systemctl restart httpd

echo ================================================================================
