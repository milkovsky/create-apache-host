#!/bin/bash

if [[ $# -lt 1 || $1 == "--help" || $1 == "-h" ]]
then
  echo "Usage:"
  echo "  sudo `basename $0` SITENAME"
  echo "Examples:"
  echo "  sudo `basename $0` drupal-8"
  exit
fi

USER="milkovsky"
WORKDIR="/home/$USER/projects"
APACHEDIR="/etc/apache2/sites-available"
HOSTSFILE="/etc/hosts"

mkdir $WORKDIR/$1/
mkdir $WORKDIR/$1/www

echo "<VirtualHost *:80>
	ServerName $1.local
	ServerAlias www.$1.local
	DocumentRoot $WORKDIR/$1/www
	<Directory \"$WORKDIR/$1/www\">
		Options FollowSymLinks
		AllowOverride All
		Require all granted
        </Directory>
</VirtualHost>" > $APACHEDIR/$1.conf
a2ensite $1
service apache2 restart
grep -q "127.0.0.1	$1.local	www.$1.local" $HOSTSFILE
if [ $? -ne 0 ]; then
  echo "127.0.0.1	$1.local	www.$1.local" >> $HOSTSFILE
fi

sudo chmod -R 777 $WORKDIR/$1/
sudo chown -R $USER:$USER $WORKDIR/$1/

