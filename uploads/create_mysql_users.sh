#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

   
   DBNAME=${MYSQL_DBNAME:-'wordpress'}
   DBUSER=${MYSQL_USER:-'admin'}
   DBPASS=${MYSQL_PASS:-'admin'}
   VIRTUAL_HOST=${VIRTUAL_HOST:-'localhost'}

   WPUSER=${WP_USER:-'admin'}
   WPPASS=${WP_PASS:-'password'}
   WPEMAIL=${USER_EMAIL:-'support@'$VIRTUAL_HOST}

   echo "=> Creating MySQL $DBUSER user with ${_word} password"
   echo "================================================================ "
   echo "DB USER => $DBUSER"
   echo "DB PASSWORD => $DBPASS"
   echo "DB NAME => $DBNAME"
   echo "WP USER => $WPUSER"
   echo "WP PASS => $WPPASS"
   echo "WP MAIL -> $WPEMAIL"
   echo "================================================================ "
   mysql -uroot -e "CREATE DATABASE $DBNAME"
   mysql -uroot -e "CREATE USER '$DBUSER'@'%' IDENTIFIED BY '$DBPASS'"
   mysql -uroot -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%' WITH GRANT OPTION"

   wp core download --path=/var/www/html --allow-root
   wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS   --path=/var/www/html --allow-root
   wp core install --url=$VIRTUAL_HOST --title=$VIRTUAL_HOST --admin_user=$WPUSER --admin_password=$WPPASS --admin_email=$WPEMAIL --path=/var/www/html --allow-root
    
echo "enjoy!"
echo "========================================================================"

mysqladmin -uroot shutdown
