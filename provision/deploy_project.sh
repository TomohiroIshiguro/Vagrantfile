#!/bin/sh

# このファイルで使用する変数をまとめてあります・
# 各自のGitlabログイン情報に読み替えてください。
gitlab_user=taro
gitlab_pass=passw0rd

work_directory=/var/www/project
clone_location=/var/www
branch='-b develop'
repository_url=https://${gitlab_user}:${gitlab_pass}@github.com/account/project.git

domain_name=vm.local
mysql_root_password=Root-000


echo --------------------------------------------------------------------------------
echo develop Application
echo --------------------------------------------------------------------------------

# プロジェクトを配置する (新規作成 / Gitリポジトリからクローン など)
cd ${clone_location}
sudo git clone ${branch} ${repository_url}

cd ${work_directory}
/usr/local/bin/composer install

# .env

# データベーススキーマを作成する
mysql -u root --password=${mysql_root_password} --connect-expired-password < /vagrant/provision/database_init.sql


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
