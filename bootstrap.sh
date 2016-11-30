apt-get -y update

#Flask Setup
apt-get -y install python2.7-dev python-virtualenv
mkdir /var/www
ln -s /home/vagrant/site /var/www/myapp

virtualenv /home/vagrant/venv
source /home/vagrant/venv/bin/activate
pip install flask
pip install requests
pip install pymysql

# UWSGI Setup
apt-get -y install uwsgi uwsgi-plugin-python
mkdir /var/www/run
chown www-data:www-data /var/www/run
touch /var/log/uwsgi/emperor.log
chown www-data:www-data /var/log/uwsgi/emperor.log
touch /var/log/uwsgi/app/myapp.log
chown www-data:www-data /var/log/uwsgi/app/myapp.log
cp /vagrant/uwsgi.conf /etc/init
cp /vagrant/uwsgi_config.ini /etc/uwsgi/apps-available/
ln -s /etc/uwsgi/apps-available/uwsgi_config.ini /etc/uwsgi/apps-enabled

# NGINX Setup
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
cp /vagrant/nginx_config /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled

# Start UWSGI and NGINX
service nginx restart
service uwsgi restart

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
