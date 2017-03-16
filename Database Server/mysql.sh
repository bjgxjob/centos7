# Install repos
rpm -Uvh http://repo.mysql.com/mysql57-community-release-el7-9.noarch.rpm

# Install mysql-server
yum install mysql-server -y

# Start with OS
systemctl enable mysqld
systemctl start mysqld

# Get a temporary password
grep 'temporary password' /var/log/mysqld.log

# Start secure install Accept all asked by Y
mysql_secure_installation

# Connect mysql server 
mysql -u root -p

# Create you database
CREATE DATABASE database_name;

# Create user with specific ip and password, 111.111.111.111 is your remote ip where you want to connect mysql remotly if you dont replace ip with 127.0.0.1, 1234567 is your password ( you should chosee good one ) 
CREATE USER 'database_username'@'111.111.111.111' IDENTIFIED BY '1234567';

# Privilages for database_username
GRANT ALL PRIVILEGES ON *.* TO 'database_username'@'111.111.111.111';

# Check what you did
SELECT  Host,User,Grant_priv,Show_db_priv,Super_priv,Show_view_priv,authentication_string FROM mysql.user;

# Apply changes now
FLUSH PRIVILEGES;

exit