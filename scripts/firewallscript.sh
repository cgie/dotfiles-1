#!/bin/bash

IPTABLES=/usr/sbin/iptables
IP6TABLES=/usr/sbin/ip6tables
VERB="-v"
IF_INT="eth0"
IF_INT2="eth1"
IF_WLAN="wlan0"
MODPROBE=/sbin/modprobe
INT_NET=192.168.0.1/24

### flush existing rules and set chain policy setting to DROP

flush() {
echo "[+] Flushing existing iptables rules..."

$IPTABLES -F $VERB
$IPTABLES -F -t nat $VERB
$IPTABLES -X $VERB
}

standard_policy() {
echo "[+] Setting standard policy..."

$IPTABLES -P INPUT $1 $VERB
$IPTABLES -P OUTPUT $1 $VERB
$IPTABLES -P FORWARD $1 $VERB

### this policy does not handle IPv6 traffic except to drop it.
echo "[+] Disabling IPv6 traffic..."
$IP6TABLES -P INPUT DROP $VERB
$IP6TABLES -P OUTPUT DROP $VERB
$IP6TABLES -P FORWARD DROP $VERB
}

load_modules() {
### load connection-tracking modules
echo "[+] Loading modules"
$MODPROBE ip_conntrack
$MODPROBE iptable_nat
$MODPROBE ip_conntrack_ftp
$MODPROBE ip_nat_ftp
}

###### INPUT chain ######
load_rules() {
echo "[+] Setting up INPUT chain..."

### state tracking rules
$IPTABLES -A INPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options $VERB
$IPTABLES -A INPUT -m state --state INVALID -j DROP $VERB
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT $VERB

### anti-spoofing rules
$IPTABLES -A INPUT -i $IF_INT ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT " $VERB
$IPTABLES -A INPUT -i $IF_INT ! -s $INT_NET -j DROP $VERB

### ACCEPT rules

# SSH
#$IPTABLES -A INPUT -i $IF_INT -p tcp -s $INT_NET --dport 22 --syn -m state --state NEW -j ACCEPT $VERB
# PING
#$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT $VERB

### default INPUT LOG rule
$IPTABLES -A INPUT ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options $VERB

### make sure that loopback traffic is accepted
$IPTABLES -A INPUT -i lo -j ACCEPT $VERB

###### OUTPUT chain ######

echo "[+] Setting up OUTPUT chain..."

### state tracking rules
$IPTABLES -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options $VERB
$IPTABLES -A OUTPUT -m state --state INVALID -j DROP $VERB
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT $VERB

### ACCEPT rules for allowing connections out

# FTP (control)
#$IPTABLES -A OUTPUT -p tcp --dport 21 --syn -m state --state NEW -j ACCEPT $VERB
# SSH
#$IPTABLES -A OUTPUT -p tcp --dport 22 --syn -m state --state NEW -j ACCEPT $VERB
# SMTP
#$IPTABLES -A OUTPUT -p tcp --dport 25 --syn -m state --state NEW -j ACCEPT $VERB
# WHOIS
$IPTABLES -A OUTPUT -p tcp --dport 43 --syn -m state --state NEW -j ACCEPT $VERB
# HTTP
$IPTABLES -A OUTPUT -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT $VERB
# HTTPS
$IPTABLES -A OUTPUT -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT $VERB
# REFERRAL WHOIS
$IPTABLES -A OUTPUT -p tcp --dport 4321 --syn -m state --state NEW -j ACCEPT $VERB
# DNS
$IPTABLES -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT $VERB
$IPTABLES -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT $VERB
# PING
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT $VERB

### default OUTPUT LOG rule
$IPTABLES -A OUTPUT ! -o lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options $VERB

### make sure that loopback traffic is accepted
$IPTABLES -A OUTPUT -o lo -j ACCEPT $VERB

###### FORWARD chain ######

echo "[+] Setting up FORWARD chain..."

### state tracking rules
$IPTABLES -A FORWARD -m state --state INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options $VERB
$IPTABLES -A FORWARD -m state --state INVALID -j DROP $VERB
#$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT $VERB

### anti-spoofing rules
$IPTABLES -A FORWARD -i eth1 ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT " $VERB
$IPTABLES -A FORWARD -i eth1 ! -s $INT_NET -j DROP $VERB

### ACCEPT rules
#$IPTABLES -A FORWARD -p tcp -i $IF_INT -s $INT_NET --dport 21 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp -i $IF_INT -s $INT_NET --dport 22 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp -i $IF_INT -s $INT_NET --dport 25 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp -i $IF_INT -s $INT_NET --dport 43 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp -i $IF_INT -s $INT_NET --dport 4321 --syn -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p tcp --dport 53 -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p udp --dport 53 -m state --state NEW -j ACCEPT $VERB
#$IPTABLES -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT $VERB

### default LOG rule
$IPTABLES -A FORWARD ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options $VERB

###### NAT rules ######

#echo "[+] Setting up NAT rules..."
#$IPTABLES -t nat -A PREROUTING -p tcp --dport 80 -i $IF_INT2 -j DNAT --to 192.168.10.3:80
#$IPTABLES -t nat -A PREROUTING -p tcp --dport 443 -i $IF_INT2 -j DNAT --to 192.168.10.3:443
#$IPTABLES -t nat -A PREROUTING -p udp --dport 53 -i $IF_INT2 -j DNAT --to 192.168.10.4:53
#$IPTABLES -t nat -A POSTROUTING -s $INT_NET -o $IF_INT2 -j MASQUERADE

###### forwarding ######

#echo "[+] Enabling IP forwarding..."
#echo 1 > /proc/sys/net/ipv4/ip_forward
}

case "$1" in
   start)
      echo "Configuring firewall... "
      flush
      standard_policy DROP
      load_modules
      load_rules
   ;;
   stop)
      echo "Resetting firewall... "
      flush
      standard_policy ACCEPT
   ;;
   status)
      echo "Status..."
      $IPTABLES -L -n -v --line-numbers > /tmp/firewall.out
      more >> /tmp/firewall.out
      $IPTABLES -t nat -L -n -v --line-numbers >> /tmp/firewall.out
      cat /tmp/firewall.out | less
      rm /tmp/firewall.out
      #watch --interval 0 'iptables -nvL | grep -v "0 0"'
   ;;
   *)
      echo "Usage:  `basename $0`  start|stop|status"
      exit 1
   ;;
esac

### EOF ###
