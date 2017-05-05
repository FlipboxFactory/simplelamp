#!/bin/sh

###########################################################################
# PHP
###########################################################################
echo "${TEXT_BOLD}"
echo "Installing MYSQL----------------------------------------"
echo "${TEXT_NORM}"

echo "mysql-server mysql-server/root_password password ${DB_PASS}" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${DB_PASS}" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.6

sudo update-rc.d mysql defaults
sudo update-rc.d apache2 defaults

# Create the database
mysql -u root -p$DB_PASS -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;"

# Create the user
mysql -u root -p$DB_PASS -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON ${DB_NAME} . * TO '${DB_USER}'@'localhost';"

if [ ! -z "$DATABASE_LOCATION" ] && [ -e "$DATABASE_LOCATION" ]
then
    #DATABASE_LOCATION file exists, load
    echo "Loading DB at ${DATABASE_LOCATION}";
    mysql -u root -p$DB_PASS $DB_NAME < $DATABASE_LOCATION && echo "DB at ${DATABASE_LOCATION} loaded successfully.";
fi

###########################################################################
# FINISH
###########################################################################
