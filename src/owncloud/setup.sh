/etc/init.d/apache2 start
echo -n "Enter your server name > "
read text
echo "ServerName $text" >> /etc/apache2/apache2.conf
apache2ctl configtest
/etc/init.d/apache2 restart
#check if firewall allows http and https traffic
ufw app list
#this should show port 80 ad 443
ufw app info "Apache Full"
#allow incoming traffic for profile
ufw allow in "Apache Full"
#check server contact using ping
ping -q -c5 $text > /dev/null
#chek if server is available
if [ $? -eq 0 ]
then
	echo "Connection to $text is successfully established."
fi
#Install MySql
echo "Generate MySql password"
MYSQL_PASS=`pwgen -s 40 1`
echo $MYSQL_PASS
export DEBIAN_FRONTEND=noninteractive
echo "mysql-server-5.6 mysql-server/root_password password $MYSQL_PASS" |  debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_PASS" |  debconf-set-selections
apt-get -y install mysql-server
#install php
apt-get -y install php libapache2-mod-php php-mcrypt php-mysql
#move php file to the first position within the string
sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g'  /etc/apache2/mods-enabled/dir.conf
#Restart Apache
/etc/init.d/apache2 restart
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
#start MySql server
/etc/init.d/mysql start
#Configure MySql Database
PASS=`pwgen -s 40 1`
echo  "Creating OwnCloud password"
echo $PASS
mysql -u root -p$MYSQL_PASS -e "CREATE DATABASE owncloud; GRANT ALL ON owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY '$PASS';"
touch info.txt
echo "MySQL user created.  " >> info.txt
echo "MySQL root pwd: $MYSQL_PASS" >> info.txt
echo "Create Owncloud user:"
echo "Username:   owncloud" >> info.txt
echo "Password:   $PASS" >> info.txt
