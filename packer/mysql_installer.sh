#!/bin/bash

echo "***************** Prepare the system *****************"
echo
sudo yum update -y
#yum install sudo wget systemd -y
echo
echo "***************** Download and install MySQL *****************"
echo
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld.service
echo
echo "***************** Perform initial configuration *****************"
echo
DEFAULT_PASS=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{ print $11 }')
mysqladmin -u root -p"$DEFAULT_PASS" password "$ROOT_PASS"
mysql -u root -p"$ROOT_PASS" -e "show databases"
mysql -u root -p"$ROOT_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$ROOT_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$ROOT_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$ROOT_PASS" -e "FLUSH PRIVILEGES"
mysql -u root -p"$ROOT_PASS" -e "show databases"
echo
echo "***************** Configure db_user and allow remote access *****************"
echo
sudo chmod 646 /etc/my.cnf
echo "bind-address = 0.0.0.0" >> /etc/my.cnf
cat /etc/my.cnf
mysql -u root -p"$ROOT_PASS" -e "CREATE USER '$DB_USER_NAME'@'localhost' IDENTIFIED BY '$DB_USER_PASS';"
mysql -u root -p"$ROOT_PASS" -e "CREATE USER '$DB_USER_NAME'@'%' IDENTIFIED BY '$DB_USER_PASS';"
mysql -u root -p"$ROOT_PASS" -e "GRANT ALL ON *.* TO '$DB_USER_NAME'@'localhost';"
mysql -u root -p"$ROOT_PASS" -e "GRANT ALL ON *.* TO '$DB_USER_NAME'@'localhost';"
mysql -u root -p"$ROOT_PASS" -e "FLUSH PRIVILEGES"
sudo systemctl stop mysqld.service
sudo systemctl start mysqld.service
echo
echo "***************** Finished!! *****************"
