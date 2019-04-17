#!/bin/bash
#wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
cp -rf /var/www/html/HDP/centos7/2.x/updates/2.4.2.0/repodata /var/www/html/HDP/repodata 
yum install ambari-server -y

PGPASSWORD=AMBARIPASSWORD psql -f /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql  -U ambariuser -d ambaridatabase
ambari-server setup --jdbc-db=postgres --jdbc-driver=/usr/share/java/postgresql-jdbc.jar
ambari-server start

for i in {1..3}
do
 ssh node$i "sudo yum install ambari-agent -y"
 ssh node$i "sudo su -c 'cat >>/etc/ambari-agent/conf/ambari-agent.ini <<EOL
			[server]
			hostname=node1
			url_port=8440
			secured_url_port=8441
			EOL'"
 ssh node$i "sudo ambari-agent start"
done
