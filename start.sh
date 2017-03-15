# Change password
passwd

# Install RPMs
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# If you are on a virtual machine 
yum install open-vm-tools -y
systemctl start vmtoolsd.service
systemctl enable vmtoolsd.service

# Kind of task manager
yum install htop -y

# Text editor
yum install nano -y

# watch interfaces, pipes, sockets, directories, devices
yum install lsof -y

# Network Time Protocol
yum install ntp -y

# old school Firewall
yum install iptables-services -y

# Remove if you will not use mail things
yum remove postfix -y

systemctl start vmtoolsd.service
systemctl enable vmtoolsd.service
