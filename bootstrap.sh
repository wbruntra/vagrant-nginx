apt-get -y update

#Flask Setup
apt-get -y install python2.7-dev python-virtualenv
mkdir /var/www
ln -s /home/vagrant/site /var/www/myapp

virtualenv /home/vagrant/venv
source /home/vagrant/venv/bin/activate
pip install flask
pip install requests

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

#MySQL setup
debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"

apt-get install -y mysql-server-5.6

mysql_secure_installation
