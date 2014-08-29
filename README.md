# Flask Deployment Demo

A basic deployment example for [Flask](http://flask.pocoo.org/) using [Nginx](http://nginx.org/) with [uWSGI](https://uwsgi-docs.readthedocs.org/en/latest/). Runs on Ubuntu 14.04 and makes use of [Upstart](http://upstart.ubuntu.com/) and [uWSGI Emperor](http://uwsgi-docs.readthedocs.org/en/latest/Emperor.html).

## File Description
* **bootstrap.sh**: Shell script used to install requirements, move files and modify permissions as needed.
* **nginx_config**:	Nginx Configuration
* **uwsgi_config.ini**: uWSGI Configuration
* **uwsgi.conf**: uWSGI Upstart Configuration

## Vagrant Usage
To replicate this setup on your local machine download [Vagrant](https://www.vagrantup.com/) and run `vagrant up` from within the project directory. This will make the example available at `localhost:8080`.
