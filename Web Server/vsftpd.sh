
# Install vsftpd 
yum install vsftpd -y 

# Open config file
nano /etc/vsftpd/vsftpd.conf

# Delete all and paste thesee 9921 is new ftp port 
anonymous_enable=NO
local_enable=YES
listen_port=9921
chroot_local_user=YES
allow_writeable_chroot=YES

write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

# Start with OS
systemctl enable vsftpd
systemctl start vsftpd

# Add ftp to  iptables 
nano /etc/sysconfig/iptables
		
#ALLOW FTP 111.111.111.111  is your allowed ip 
-A INPUT -s 111.111.111.111 -p tcp -m tcp --dport 9921 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 9921 -j DROP