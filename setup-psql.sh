#!/bin/bash
yum localinstall https://download.postgresql.org/pub/repos/yum/9.3/redhat/rhel-7-x86_64/pgdg-redhat93-9.3-2.noarch.rpm -y
yum list postgres* -y
yum install postgresql93-server.x86_64 -y
/usr/pgsql-9.3/bin/postgresql93-setup initdb
systemctl enable postgresql-9.3.service
systemctl start postgresql-9.3.service

sed -i 's/ident/md5/' /var/lib/pgsql/9.3/data/pg_hba.conf #replace ident to md5
sed -i 's/peer/md5/' /var/lib/pgsql/9.3/data/pg_hba.conf

sed -i 's/localhost/*/' /var/lib/pgsql/9.3/data/postgresql.conf #change listen_addresses from  ‘localhost’ to *

#Install and configure AMBARI database
sudo -u postgres psql -c 'CREATE DATABASE AMBARIDATABASE;'
sudo -u postgres psql -c "CREATE USER AMBARIUSER WITH PASSWORD 'AMBARIPASSWORD'";
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE AMBARIDATABASE TO AMBARIUSER";
sudo -u postgres psql -c "ALTER DATABASE AMBARIDATABASE OWNER TO AMBARIUSER";

#Install and configure HIVE database
sudo -u postgres psql -c "CREATE DATABASE HIVEDATABASE;"
sudo -u postgres psql -c "CREATE USER HIVEUSER WITH PASSWORD 'HIVEPASSWORD';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE HIVEDATABASE TO HIVEUSER;"
sudo -u postgres psql -c "ALTER DATABASE HIVEDATABASE OWNER TO HIVEUSER;"

#Install and configure OOZIE database
sudo -u postgres psql -c "CREATE DATABASE OOZIEDATABASE;"
sudo -u postgres psql -c "CREATE USER OOZIEUSER WITH PASSWORD 'OOZIEPASSWORD';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE OOZIEDATABASE TO OOZIEUSER;"
sudo -u postgres psql -c "ALTER DATABASE OOZIEDATABASE OWNER TO OOZIEUSER"

#Install and configure Ranger database
sudo -u postgres psql -c "CREATE DATABASE RANGERDATABASE;"
sudo -u postgres psql -c "CREATE USER RANGERUSER WITH PASSWORD ‘RANGERPASSWORD’;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE RANGERDATABASE TO RANGERUSER;"
sudo -u postgres psql -c "ALTER DATABASE RANGERDATABASE OWNER TO RANGERUSER"

systemctl restart postgresql-9.3.service
