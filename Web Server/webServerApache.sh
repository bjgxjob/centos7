
# Check repos installed 
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Install httpd and php7
yum --enablerepo=remi,remi-php70 install php-fpm php php-common php-pdo php-mysqlnd php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

# Install mod_ssl if you will use SSL ( you should)
yum install mod_ssl -y
	
# Backup orginal Apache config fle
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.bak 

# Open config file 
nano /etc/httpd/conf/httpd.conf

ServerRoot "/etc/httpd"
ServerTokens Prod 
ServerSignature Off

Listen 80
Include conf.modules.d/*.conf

User apache
Group apache

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

<IfModule mime_module>
    TypesConfig /etc/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz

    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>

EnableSendfile on

IncludeOptional conf.d/*.conf

# If you want to watch your server status there is mod_status
# Check apache modules to see if mod_status installed
httpd -t
#LoadModule status_module modules/mod_status.so

# Add your htaccess file ( if you have )
RewriteEngine On
RewriteCond %{REQUEST_URI} !=/server-status

# This is your URL, 111.111.111.111 is you server ip
https://111.111.111.111/server-status?refresh=1

# Add this to Virtual host config file ( you will see details in domain.sh) 222.222.222.222 is where you want to access server status since it is a bad idea to open that world wide
<Location /server-status>
   SetHandler server-status
   Require ip 127.0.0.1 222.222.222.222
</Location>

# There is tons of comments on config files so i will delete and recreate them 			
rm -rf /etc/httpd/conf.d/*

cd /etc/httpd/conf.d/

# Open autoindex.conf 
nano autoindex.conf

# Paste all of them
IndexOptions FancyIndexing HTMLTable VersionSort

Alias /icons/ "/usr/share/httpd/icons/"

<Directory "/usr/share/httpd/icons">
    Options Indexes MultiViews FollowSymlinks
    AllowOverride None
    Require all granted
</Directory>

AddIconByEncoding (CMP,/icons/compressed.gif) x-compress x-gzip

AddIconByType (TXT,/icons/text.gif) text/*
AddIconByType (IMG,/icons/image2.gif) image/*
AddIconByType (SND,/icons/sound2.gif) audio/*
AddIconByType (VID,/icons/movie.gif) video/*

AddIcon /icons/binary.gif .bin .exe
AddIcon /icons/binhex.gif .hqx
AddIcon /icons/tar.gif .tar
AddIcon /icons/world2.gif .wrl .wrl.gz .vrml .vrm .iv
AddIcon /icons/compressed.gif .Z .z .tgz .gz .zip
AddIcon /icons/a.gif .ps .ai .eps
AddIcon /icons/layout.gif .html .shtml .htm .pdf
AddIcon /icons/text.gif .txt
AddIcon /icons/c.gif .c
AddIcon /icons/p.gif .pl .py
AddIcon /icons/f.gif .for
AddIcon /icons/dvi.gif .dvi
AddIcon /icons/uuencoded.gif .uu
AddIcon /icons/script.gif .conf .sh .shar .csh .ksh .tcl
AddIcon /icons/tex.gif .tex
AddIcon /icons/bomb.gif /core

AddIcon /icons/bomb.gif */core.*

AddIcon /icons/back.gif ..
AddIcon /icons/hand.right.gif README
AddIcon /icons/folder.gif ^^DIRECTORY^^
AddIcon /icons/blank.gif ^^BLANKICON^^

DefaultIcon /icons/unknown.gif

ReadmeName README.html
HeaderName HEADER.html

IndexIgnore .??* *~ *# HEADER* README* RCS CVS *,v *,t

# Open php.conf 
nano php.conf

# Paste all of them	
<Files ".user.ini">
    <IfModule mod_authz_core.c>
        Require all denied
    </IfModule>
    <IfModule !mod_authz_core.c>
        Order allow,deny
        Deny from all
        Satisfy All
    </IfModule>
</Files>


AddType text/html .php

DirectoryIndex index.php

<IfModule  mod_php7.c>
  
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    php_value session.save_handler "files"
    php_value session.save_path    "/var/lib/php/session"
    php_value soap.wsdl_cache_dir  "/var/lib/php/wsdlcache"

</IfModule>


# Open userdir.conf	 
nano userdir.conf

# Paste all of them
<IfModule mod_userdir.c>
    UserDir disabled
</IfModule>

<Directory "/home/*/public_html">
    AllowOverride FileInfo AuthConfig Limit
    Options SymLinksIfOwnerMatch IncludesNoExec
    Require method GET POST OPTIONS
</Directory>

# Start with OS	
systemctl enable httpd
systemctl start httpd

# Here is how to delete or install some php modules 
yum --enablerepo=remi,remi-php70 remove httpd php php-common php-pdo php-mysqlnd php-pecl-mongodb php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
yum remove mod_ssl -y
yum --enablerepo=remi,remi-php70 install httpd php php-common 
yum --enablerepo=remi,remi-php70 install php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
yum remove php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
yum --enablerepo=remi,remi-php70 install php-pear php-devel 

# END OF Apache Web Server ( Check domain.sh for virtual hosts)