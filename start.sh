
passwd

rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm


yum install open-vm-tools -y
yum install htop -y
yum install nano -y
yum install lsof -y
yum install ntp -y
yum install iptables-services -y
yum remove postfix -y

systemctl start vmtoolsd.service
systemctl enable vmtoolsd.service