#!/bin/bash -x
## @author Oliver Nassar <onassar@gmail.com>
## Ubuntu 11.10 VPN

## Sample Usage:
## 
## cd
## sudo vi vpn-setup.sh
## sudo chmod +x vpn-setup.sh
## sudo ./vpn-setup.sh <username> <password>


## 0.1 Username/Password Check
## Checks to make sure *2* parameters were specified
##
if [ $# -ne 2 ]
then
    echo "Usage: sudo ./`basename $0` <username> <password>"
    exit 0
fi
USERNAME=$1
PASSWORD=$2


## 1.0 VPN Setup
##
##
sudo apt-get -y remove pptpd
sudo apt-get -y install pptpd
echo "$USERNAME pptpd $PASSWORD *" | sudo tee -a /etc/ppp/chap-secrets
sudo perl -0 -p -i -e 's/\n#net.ipv4.ip_forward=1/\nnet.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo perl -0 -p -i -e 's/\nexit 0/\n\n# <build script modifications>\n    \sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE\n# <\/build script modifications>\n\nexit 0/' /etc/rc.local
sudo /etc/init.d/pptpd restart
