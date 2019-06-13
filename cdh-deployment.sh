#!/bin/bash

#sudo wget https://archive.cloudera.com/cm6/6.2.0/cloudera-manager-installer.bin
#sudo chmod a+x cloudera-manager-installer.bin
#sudo ./cloudera-manager-installer.bin
#sudo systemctl restart cloudera-scm-server
#sudo systemctl enable cloudera-scm-server

####### Path B ########

sudo yum -y install psmisc wget 

sudo mkdir -p /var/www/html/{CM5.14,PARCEL,redhat}
sudo mkdir -p /var/www/html/CM5.14/{repodata,RPMS}

#RPMS
cd /var/www/html/CM5.14/RPMS
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/RPMS/x86_64/cloudera-manager-agent-5.14.4-1.cm5144.p0.3.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/RPMS/x86_64/cloudera-manager-daemons-5.14.4-1.cm5144.p0.3.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/RPMS/x86_64/cloudera-manager-server-5.14.4-1.cm5144.p0.3.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/RPMS/x86_64/cloudera-manager-server-db-2-5.14.4-1.cm5144.p0.3.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/RPMS/x86_64/enterprise-debuginfo-5.14.4-1.cm5144.p0.3.el7.x86_64.rpm


#Repodata
cd /var/www/html/CM5.14/repodata
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/filelists.xml.gz
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/filelists.xml.gz.asc
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/other.xml.gz
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/other.xml.gz.asc
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/primary.xml.gz
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/primary.xml.gz.asc
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/repomd.xml
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14/repodata/repomd.xml.asc

#RPM-KEY cloudera 
cd /var/www/html/CM5.14
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera

#Cloudera repo
cd /etc/yum.repos.d/ 
sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo

#Parcel
cd /var/www/html/PARCEL
sudo wget https://archive.cloudera.com/cdh5/parcels/5.14/CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel
sudo wget https://archive.cloudera.com/cdh5/parcels/5.14/CDH-5.14.4-1.cdh5.14.4.p0.3-el7.parcel.sha1
sudo wget https://archive.cloudera.com/cdh5/parcels/5.14/manifest.json


sudo curl http://127.0.0.1/CM5.14/RPMS/

sudo yum install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
sudo systemctl enable mysqld.service

cd
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar zxvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar

sudo yum install cloudera-manager-server

sudo /usr/share/cmf/schema/scm_prepare_database.sh -h 127.0.0.1 mysql scm scm scm_password
#sudo /usr/share/cmf/schema/scm_prepare_database.sh database-type mysql scm root 12345

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm_password';

CREATE DATABASE amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON amon.* TO 'amon'@'%' IDENTIFIED BY 'amon_password';

CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rman_password';

CREATE DATABASE metastore DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON metastore.* TO 'metastore'@'%' IDENTIFIED BY 'metastore_password';

CREATE DATABASE sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry_password';

CREATE DATABASE nav DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON nav.* TO 'nav'@'%' IDENTIFIED BY 'nav_password';

CREATE DATABASE navms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'navms_password';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie_password';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hue_password';

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm_password';

sudo systemctl restart cloudera-scm-server
sudo systemctl enable cloudera-scm-server
