#!/bin/sh
iptables-restore /etc/iptables.rules;
iptables -I INPUT -p tcp --dport 27017 -j ACCEPT;
iptables -I INPUT -p tcp --dport 28017 -j ACCEPT;
iptables -I INPUT -p tcp --dport 8808  -j ACCEPT;
iptables -I INPUT -p tcp --dport 5000  -j ACCEPT;
iptables -I INPUT -p tcp --dport 9292  -j ACCEPT;
iptables -I INPUT -p tcp --dport 4242  -j ACCEPT;
iptables -I INPUT -p tcp --dport 3000  -j ACCEPT;
iptables -I INPUT -p tcp --dport 2628  -j ACCEPT;
iptables -I INPUT -p tcp --dport 6379  -j ACCEPT;
iptables -I INPUT -p tcp --dport 5678  -j ACCEPT;
iptables -I INPUT -p tcp --dport 4567  -j ACCEPT;
iptables -I INPUT -p tcp --dport 8332  -j ACCEPT;
iptables -I INPUT -p tcp --dport 8333  -j ACCEPT;
