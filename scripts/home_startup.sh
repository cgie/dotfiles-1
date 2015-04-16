#!/bin/bash

sudo service bastion stop
sudo service network-manager stop
sudo ifconfig wlan2 down
sudo ifconfig wlan2 up

