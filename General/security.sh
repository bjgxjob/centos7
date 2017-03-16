# If you not sure what is SELinux first check it out from https://wiki.centos.org/HowTos/SELinux If you really want to disable it

# Open selinux config file
nano /etc/sysconfig/selinux

# Replace SELINUX=enforcing line to 
SELINUX=disabled

# I still use iptables not firewalld 
systemctl stop firewalld
systemctl mask firewalld

# Start with OS
systemctl enable iptables
systemctl start iptables

# Basic iptables sample ( I always edit from file ) Open config file
nano /etc/sysconfig/iptables

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

-A INPUT -s <allowed ip address> -p tcp -m tcp --dport <allowed port> -j ACCEPT
# New SSH port sample replace 111.111.111.111 to your ip where you want to allow to connect SSH, 9922 is my new SSH port
-A INPUT -s 111.111.111.111 -p tcp -m tcp --dport 9922 -j ACCEPT


# NTP SERVER
-A INPUT -p udp --dport 123 -j ACCEPT

# DROP
-A INPUT -p tcp -m tcp --dport <port to disable except allowed> -j DROP

COMMIT

# Restart iptables to apply new rules
systemctl restart iptables

# Open SSH config file, 9922 is my new SSH port replace to 
nano /etc/ssh/sshd_config
Port = 9922
ListenAddress 0.0.0.0
Protocol 2

# Reload SSH Deamon to appyl new config
systemctl reload sshd

#END OF SECURITY