#!/bin/bash

# start xscreensaver
echo 'start xscreensaver'
xscreensaver -nosplash &

# NetworkManager stop
sudo service network-manager stop

# start dropbox
dropbox start

# enable dual-screen
echo 'set dual-screen'
xrandr --output LVDS1 --auto --output VGA1 --auto --left-of LVDS1

echo '--------------'
echo '-- DB status'
echo 'MySQL'
sudo service mysql status
echo 'PostgreSQL'
sudo service postgresql status
echo 'MongoDB'
sudo service mongodb status

echo 'MySQL start'
sudo service mysql start

echo 'MongoDb start'
sudo service mongodb start

echo 'PostgreSQL start'
sudo service postgresql start
