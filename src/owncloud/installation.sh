echo -n "Enter your server name > "
read text
echo "ServerName $text" >> /etc/apache2/apache2.conf
apache2ctl configtest
systemctl restart apache2
#check if firewall allows http and https traffic
ufw app list
#this should show port 80 ad 443
ufw app info "Apache Full"
#allow incoming traffic for profile
ufw allow in "Apache Full"
#check server contact using ping
ping -q -c5 $text > /dev/null

if [ $? -eq 0 ]
then
	echo "Connection to $text is successfully established."
fi

#install MySql server
apt-get -y install mysql-server

#install php
apt-get -y install php libapache2-mod-php php-mcrypt php-mysql
#move php file to the first position within the string
sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g'  /etc/apache2/mods-enabled/dir.conf
#Restart Apache
systemctl restart apache2

#Download OwnCloud installation key
curl https://download.owncloud.org/download/repositories/stable/Ubuntu_16.04/Release.key | apt-key add -
#add file to apt sources
touch /etc/apt/sources.list.d/owncloud.list
echo 'deb https://download.owncloud.org/download/repositories/stable/Ubuntu_16.04/ /' |  tee /etc/apt/sources.list.d/owncloud.list
#Update apt
apt-get install apt-transport-https
apt-get update
#Install OwnCloud
apt-get -y install owncloud owncloud-deps-php7.0 owncloud-files

#Configure MySql Database
apt-get -y install pwgen
PASS=`pwgen -s 40 1`

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE owncloud;
GRANT ALL ON owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY 'set_database_password';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created."
echo "Username:   owncloud"
echo "Password:   $PASS"
