-- データベースの作成
CREATE DATABASE myapp_database;

-- ユーザーの作成
CREATE USER 'developer'@'localhost' IDENTIFIED WITH mysql_native_password BY 'MyApp-123@';

-- 権限の付与（IPアドレスによるアクセス元の制限は指定しない）
GRANT ALL ON myapp_database.* TO 'developer'@'localhost';
FLUSH PRIVILEGES;
