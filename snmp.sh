#snmp (Simple Network Management Protocol) this will help you to monitor your server
# You will need some monitoring software like PRTG ( https://www.paessler.com/download/prtg-download ) this is free up to 100 sensor

# Install SNMP 
yum install net-snmp -y

# Take a backup of original config file maybe you want to check it out
cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.bak

# Open config file
nano /etc/snmp/snmpd.conf 

# This will help you to limit who will monitor your server 
# prtg is your community string, 111.111.111.111 is your prtg server ip address
rocommunity prtg 111.111.111.111

# Start with OS
systemctl enable snmpd
systemctl start snmpd

# Do not forget to add rule to iptables
nano /etc/sysconfig/iptables
		
#ALLOW SNMP 161 is default port for SNMP
-A INPUT -s 111.111.111.111 -p udp -m udp --dport 161 -j ACCEPT

# Drop all execpt your server
-A INPUT -p udp -m udp --dport 161 -j DROP

# Restart iptables to apply new rules
systemctl restart iptables

# END OF SNMP