
yum install wget -y 
yum install httpd -y 
sudo systemctl enable httpd.service
sudo systemctl start httpd.service
wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari-2.2.2.0-centos7.tar.gz
wget http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.4.2.0/HDP-2.4.2.0-centos7-rpm.tar.gz
wget http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.20/repos/centos7/HDP-UTILS-1.1.0.20-centos7.tar.gz

tar -xvf ambari-2.2.2.0-centos7.tar.gz -C /var/www/html/
tar -xvf HDP-2.4.2.0-centos7-rpm.tar.gz -C /var/www/html/
tar -xvf HDP-UTILS-1.1.0.20-centos7.tar.gz -C /var/www/html/


sudo su -c 'cat >> /etc/yum.repos.d/AMBARI-2.2.2.0.repo <<EOL
[AMBARI-2.2.2.0]
name= AMBARI-2.2.2.0
baseurl=http://`hostname`/AMBARI-2.2.2.0/centos7/2.2.2.0-460/
gpgcheck=0
EOL'

sudo su -c 'cat >> /etc/yum.repos.d/HDP.repo <<EOL
[HDP]
name= HDP
baseurl=http://`hostname`/HDP/
gpgcheck=0
EOL'

sudo su -c 'cat >> /etc/yum.repos.d/HDP-UTILS-1.1.0.20.repo <<EOL
[HDP-UTILS-1.1.0.20]
name= HDP-UTILS-1.1.0.20
baseurl=http://`hostname`/HDP-UTILS-1.1.0.20/repos/centos7/
gpgcheck=0
EOL'



curl -s -o /dev/null -I -w "%{http_code}" http://`hostname`/HDP-UTILS-1.1.0.20/repos/centos7/
