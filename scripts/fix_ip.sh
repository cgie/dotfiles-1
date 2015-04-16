#!/bin/bash
sudo ifconfig eth0 10.6.77.141
sudo ifconfig eth0 netmask 255.255.240.0
sudo route add default gw 10.6.64.2 eth0
sudo ifconfig eth0

