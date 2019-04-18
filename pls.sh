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

for ((i=3; i>=1; i--))
do
 #ssh patel@node$i 'bash -s' < pre-req.sh   #option 1
 ssh patel@node$i 'sudo bash pre-req.sh'    #option 2
done

sudo yum install wget -y
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"

for i in {2..3}
do
 scp jdk-8u131-linux-x64.rpm patel@node$i:~/ 
done

for i in {1..3}
do
 ssh patel@node$i "sudo rpm -ivh ~/jdk-8u131-linux-x64.rpm"
done
