
# Check repos installed 
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Install nginx and php7
yum -y install nginx
yum --enablerepo=remi,remi-php70 install php-fpm php php-common php-pdo php-mysqlnd php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

# Some good security moves ( google for details )
nano /etc/php.ini
cgi.fix_pathinfo=0

# Open php-fpm config
nano /etc/php-fpm.d/www.conf

# Replace all
listen = /run/php-fpm/php-fpm.sock

listen.owner = nginx
listen.group = nginx

user = nginx
group = nginx

# Some permission moves 
chmod 666 /run/php-fpm/php-fpm.sock
chown nginx:nginx /run/php-fpm/php-fpm.sock

# Start with OS
systemctl restart php-fpm
systemctl enable php-fpm

# END OF NGINX Web Server ( Check domain.sh for virtual hosts)