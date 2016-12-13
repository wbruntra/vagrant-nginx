echo "I am a script and I am definitely running"
restart uwsgi
# Create CLI directory
echo "Creating cli directory"
mkdir /var/run/cli
chmod 777 /var/run/cli
