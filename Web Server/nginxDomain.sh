	
# Create user, domainname is your domain 
useradd domainname 
# Add password for user
passwd domainname 

# Limit to access ssh 
usermod -d /home/domainname -s /usr/sbin/nologin domainname

# Create files and folders where your code will hosted
mkdir /var/www/domainname/public_html

# Some persmisson moves to limit created user to access 
chown -R domainname:domainname /var/www/domainname/public_html
chmod -R 755 /var/www/domainname/

# Create a new virtual host config file
nano /etc/nginx/conf.d/domainname.conf
server {
  listen       80;
  server_name  domainname.com www.domainname.com;
  root   /var/www/domainname/public_htm;
  index index.php index.html index.htm;
  location / {
    try_files $uri $uri/ =404;
  }
  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
  root   /var/www/domainname/public_htm;
  }
      location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

# Save config file and exit


systemctl restart nginx	

# END OF VIRTUAL HOST domain