# Open ntp config file 
nano /etc/ntp.conf

# Replace server with europe pool (Its always good you ETC timezone)

server 0.europe.pool.ntp.org
server 1.europe.pool.ntp.org
server 2.europe.pool.ntp.org
server 3.europe.pool.ntp.org

# Start with OS
systemctl enable ntpd
systemctl start ntpd

# Check config
ntpq -p

# Check time and timezone
timedatectl

# END OF ntpConfig 