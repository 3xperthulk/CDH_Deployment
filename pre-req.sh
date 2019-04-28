#!/bin/bash

#sudo yum install wget -y
wget  -O $HOME/jdk-8u131-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"

#get mysql

#sudo yum install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm -y
#sudo yum install mysql-community-server -y
#sudo systemctl start mysqld
#sudo systemctl enable mysqld.service

for i in {2..3}
do
 scp jdk-8u131-linux-x64.rpm $username@node$i:~/ 
done

for i in {1..3}
do
 ssh $username@node$i "sudo rpm -ivh ~/jdk-8u131-linux-x64.rpm"
 sudo su -c 'cat >>/etc/profile.d/java.sh <<EOL
 JAVA_HOME=/usr/java/latest
 EOL'
source 	/etc/profile.d/java.sh
done

systemctl stop firewalld
systemctl disable firewalld

chkconfig iptables off
chkconfig ip6tables off
chkconfig ntpd on

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl -w net.ipv6.conf.all.disable_ipv6=1 
sysctl -w net.ipv6.conf.default.disable_ipv6=1
service tuned stop
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config
setenforce 0

sudo su -c 'cat >>/etc/sysctl.conf <<EOL
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL'

sudo su -c 'cat >>/etc/rc.local <<EOL
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
exit 0
EOL'

sysctl vm.swappiness=1
sudo su -c 'cat >>/etc/sysctl.conf <<EOL
'vm.swappiness=1'
EOL'
reboot
