#!/bin/bash

#####################################################
##        Author: Mehraj Patel     ##
#### note - Dont remove this section else this script won't run ;) ####
#####################################################


#sudo yum install wget -y

#username should be provided as command line parameter
username=$1
#totalnodes=$2
#for i in {1..$(seq 1 $totalnodes)};
cat $HOME/.ssh/authorized_keys >> authorized_keys
for i in `cat $HOME/hosts`
do
 ssh -i key.pem $username@$i "echo -e 'y\n' | ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa"
 ssh -i key.pem $username@$i 'touch ~/.ssh/config; echo -e \ "host *\n StrictHostKeyChecking no\n UserKnownHostsFile=/dev/null" \ > ~/.ssh/config; chmod 644 ~/.ssh/config'
 ssh -i key.pem $username@$i 'cat $HOME/.ssh/id_rsa.pub' >> authorized_keys
done

for i in `cat $HOME/hosts`
do
 scp -i key.pem authorized_keys $username@$i:$HOME/.ssh/authorized_keys
 scp -i key.pem $HOME/Hadoop-Configurations/pre-req.sh $username@$i:$HOME/ 
 ssh $username@$i 'chmod a+x pre-req.sh'
done

sudo rm ~/authorized_keys
sudo rm $HOME/Hadoop-Configurations/key.pem
sudo rm $HOME/pre-req.sh

sudo wget  -O $HOME/jdk-8u131-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"

for i in `tail -n +2 $HOME/hosts`
do
 scp $HOME/jdk-8u131-linux-x64.rpm $username@$i:~/ 
done

for i in `cat $HOME/hosts`
do
 ssh $username@$i "sudo rpm -ivh ~/jdk-8u131-linux-x64.rpm"
 ssh $username@$i "echo 'JAVA_HOME=/usr/java/latest' | sudo tee -a /etc/profile.d/java.sh"
 ssh $username@$i "source /etc/profile.d/java.sh"
done

for i in `tac $HOME/hosts`
do 
 ssh $username@$i 'sudo bash pre-req.sh $username'  
done

# Must run manually since system reboots before this
#bash $HOME/Hadoop-Configurations/cdh-deployment.sh
