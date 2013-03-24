#!/bin/sh
#echo down interface
ifconfig eth0 down
#echo .
sleep 1s
macchanger eth0 -r
#echo ..
sleep 1s
#macchanger eth0 -r
#echo ...
#sleep 1s
#macchanger eth0 -r
#echo ....
#sleep 1s
#echo up interface
ifconfig eth0 up
#echo done!
#echo down interface
ifconfig wlan0 down
#echo .
sleep 1s
macchanger wlan0 -r
#echo ..
sleep 1s
#macchanger wlan0 -r
#echo ...
#sleep 1s
#macchanger wlan0 -r
#echo ....
#sleep 1s
#echo up interface
ifconfig wlan0 up
#echo done!
/etc/rc.d/rc.inet1 restart
