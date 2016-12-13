apt-get update

#Flask Setup
mkdir /var/www
ln -s /home/vagrant/site /var/www/myapp

apt-get -y install python3-dev python3-pip
pip3 install virtualenv

# virtualenv -p python3 /home/vagrant/coolenv

# python modules depend on the following: 
apt-get -y install postgresql-server-dev-all memcached libmemcached-dev

# source /home/vagrant/coolenv/bin/activate
pip3 install --upgrade pip
pip3 install requests
pip3 install uwsgi
pip3 install pymysql
pip3 install python3-memcached
pip3 install flask
pip3 install flask-restful
pip3 install passlib
pip3 install python-magic
pip3 install pycrypto
pip3 install requests
pip3 install twilio
pip3 install geopy
pip3 install pylibmc
pip3 install mock
pip3 install phonenumbers
pip3 install boto
pip3 install psycopg2

# create sock directory for communication
mkdir /home/vagrant/hotsocks
chown vagrant:www-data /home/vagrant/hotsocks

virtualenv /home/vagrant/coolenv
source /home/vagrant/coolenv/bin/activate
pip install flask uwsgi pymysql

# create project symlinks
sudo ln -sf /home/vagrant/code/tinyAPI /opt/tinyAPI
sudo ln -sf /home/vagrant/code/cooldb/api /opt/cooldb

# setup project environmental variables and PATH
echo '' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:/opt/tinyAPI/utils' >> /home/vagrant/.bashrc
echo 'export PYTHONPATH=$PYTHONPATH:/opt:/opt/cooldb/config/local' >> /home/vagrant/.bashrc
echo 'export APP_SERVER_ENV=local' >> /home/vagrant/.bashrc


# UWSGI Setup
cp /vagrant/uwsgi.conf /etc/init/
cp /vagrant/uwsgi_config.ini /home/vagrant/site/
start uwsgi


# NGINX Setup
apt-get -y install nginx
rm /etc/nginx/sites-available/default
cp /vagrant/mysite_nginx /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/mysite_nginx /etc/nginx/sites-enabled



# Start UWSGI and NGINX
service nginx restart
# service uwsgi restart

# Variables
DBHOST=localhost
DBNAME=mytestdb
DBUSER=root
DBPASSWD=test123

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

apt-get -y install mysql-server >> /vagrant/vm_build.log 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME" >> /vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'" > /vagrant/vm_build.log
mysql -uroot -p$DBPASSWD < /vagrant/movie_db.sql
