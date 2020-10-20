CREATE DATABASE dev;

CREATE USER 'developer'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Develop@000';
GRANT ALL PRIVILEGES ON *.* TO 'developer'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;