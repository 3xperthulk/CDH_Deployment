#!/bin/bash

cat $HOME/.ssh/authorized_keys >> authorized_keys
for i in {1..3}
do
 ssh -i key.pem patel@node$i "echo -e 'y\n' | ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa"
 ssh -i key.pem patel@node$i 'touch ~/.ssh/config; echo -e \ "host *\n StrictHostKeyChecking no\n UserKnownHostsFile=/dev/null" \ > ~/.ssh/config; chmod 644 ~/.ssh/config'
 ssh -i key.pem patel@node$i 'cat $HOME/.ssh/id_rsa.pub' >> authorized_keys
done

for i in {1..3}
do
 scp -i key.pem authorized_keys patel@node$i:$HOME/.ssh/authorized_keys
 scp -i key.pem pre-req.sh patel@node$i:$HOME/  #option 2
 ssh patel@node$i 'chmod a+x pre-req.sh'		#option 2
done

sudo rm ~/authorized_keys
sudo rm key.pem

#sudo yum install wget -y
wget  -O $HOME/jdk-8u131-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"

#get mysql
#wget https://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-server-5.6.43-1.el7.x86_64.rpm
#wget https://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-client-5.6.43-1.el7.x86_64.rpm
sudo yum install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
sudo systemctl enable mysqld.service


for i in {2..3}
do
 scp jdk-8u131-linux-x64.rpm patel@node$i:~/ 
done

for i in {1..3}
do
 ssh patel@node$i "sudo rpm -ivh ~/jdk-8u131-linux-x64.rpm"
 sudo su -c 'cat >>/etc/profile.d/java.sh <<EOL
 JAVA_HOME=/usr/java/latest
 EOL'
source 	/etc/profile.d/java.sh
done

for ((i=3; i>=1; i--))
do
 #ssh patel@node$i 'bash -s' < pre-req.sh   #option 1
 ssh patel@node$i 'sudo bash pre-req.sh'    #option 2
done

#/etc/amabri-agent/conf/ambari-agent.ini
#force_https_protocol=PROTOCOL_TLSv1_2
##create database hive DEFAULT CHARACTER SET utf8;
#grant all on hive.* TO 'hive'@'%' IDENTIFIED BY 'hive';
#sudo yum install unzip -y
#wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.zip
#unzip mysql-connector-java-5.1.47.zip
#sudo mkdir -p /usr/share/java
##put this in the /usr/share/java 
#sudo mv mysql-connector-java-5.1.47.jar /usr/share/java/mysql-connector-java.jar
#sudo ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
