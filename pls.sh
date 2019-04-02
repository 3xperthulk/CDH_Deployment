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
done
