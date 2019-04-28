#!/bin/bash

sudo yum install wget -y

#username should be provided as command line parameter
username=$1
cat $HOME/.ssh/authorized_keys >> authorized_keys
for i in {1..3}
do
 ssh -i key.pem $username@node$i "echo -e 'y\n' | ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa"
 ssh -i key.pem $username@node$i 'touch ~/.ssh/config; echo -e \ "host *\n StrictHostKeyChecking no\n UserKnownHostsFile=/dev/null" \ > ~/.ssh/config; chmod 644 ~/.ssh/config'
 ssh -i key.pem $username@node$i 'cat $HOME/.ssh/id_rsa.pub' >> authorized_keys
done

for i in {1..3}
do
 scp -i key.pem authorized_keys $username@node$i:$HOME/.ssh/authorized_keys
 scp -i key.pem pre-req.sh $username@node$i:$HOME/  #option 2
 ssh $username@node$i 'chmod a+x pre-req.sh'		#option 2
done

sudo rm ~/authorized_keys
sudo rm key.pem

for ((i=3; i>=1; i--))
do
 ssh $username@node$i 'sudo bash pre-req.sh'  
done
