#!/bin/bash

sudo wget https://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin

sudo ./cloudera-manager-installer.bin
sudo systemctl restart cloudera-scm-server
sudo systemctl enable cloudera-scm-server
