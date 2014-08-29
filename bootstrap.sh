apt-get -y update

#Flask Setup
apt-get -y install python2.7-dev python-virtualenv
mkdir /var/www
mkdir /var/www/hello
cp /vagrant/hello.py /var/www/hello

virtualenv /var/www/hello/venv
source /var/www/hello/venv/bin/activate
pip install flask

# UWSGI Setup
apt-get -y install uwsgi uwsgi-plugin-python
mkdir /var/www/run
chown www-data:www-data /var/www/run
touch /var/log/uwsgi/emperor.log
chown www-data:www-data /var/log/uwsgi/emperor.log
touch /var/log/uwsgi/app/hello.log
chown www-data:www-data /var/log/uwsgi/app/hello.log
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