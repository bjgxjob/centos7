
# Create user, domainname is your domain 
useradd domainname 
# Add password for user
passwd domainname 

# Limit to access ssh 
usermod -d /home/domainname -s /usr/sbin/nologin domainname

# Create files and folders where your code will hosted
mkdir /home/domainname/public_html
mkdir /home/domainname/log
mkdir /home/domainname/ssl
touch /home/domainname/log/requests.log
touch /home/domainname/log/error.log

# Some persmisson moves to limit created user to access 
chown -R domainname /home/domainname/
chmod -R 755 /home/domainname/

# Create a new virtual host config file
nano /etc/httpd/conf.d/domainname.conf

<Directory "/home/domainname/public_html">
  AllowOverride FileInfo AuthConfig Limit
  Options MultiViews SymLinksIfOwnerMatch IncludesNoExec
  Require method GET POST OPTIONS
</Directory>

<VirtualHost *:80>
    ServerName domainname.com
    DocumentRoot /home/domainname/public_html
    ErrorLog /home/domainname/log/error.log
    CustomLog /home/domainname/log/requests.log combined
    # Redirect all requests to ssl
	RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>

<VirtualHost *:443>
     SSLEngine On
     SSLCertificateKeyFile home/domainname/ssl/domainname/domainname.key
	 SSLCertificateFile /home/domainname/ssl/domainname.crt
     SSLCertificateChainFile home/domainname/ssl/domainname/domainnameCA.crt

     ServerName domainname.com
     DocumentRoot /home/domainname/public_html
     ErrorLog /home/domainname/log/error.log
     CustomLog /home/domainname/log/requests.log combined
</VirtualHost>

# Save config file and exit

# Generate a CSR file to create a SSL Certificate 
openssl req -new -newkey rsa:2048 -nodes -keyout /home/domainname/ssl/domainname.key -out /home/domainname/ssl/domainname.csr

# When you get CRT and CA CRT files from you certificate provider 
# Paste CRT to here
nano /home/domainname/ssl/domainname.crt

# Paste CA CRT to here ( if you dont have SSLCertificateChainFile home/domainname/ssl/domainname/domainnameCA.crt delete this line from virtual host config file )
nano /home/domainname/ssl/domainname/domainnameCA.crt

# Restart Apache to apply new config 
systemctl restart httpd


# END OF VIRTUAL HOST domain