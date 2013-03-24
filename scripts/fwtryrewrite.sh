#!/bin/bash

IPT_CMD="/usr/sbin/iptables"
SW_VERB="-v"
IF_INT="eth0"
IF_WLAN="wlan0"

functions() {
# Enable TCP SYN Cookie Protection
    if [ -e /proc/sys/net/ipv4/tcp_syncookies ]; then
	echo 1 > /proc/sys/net/ipv4/tcp_syncookies
    fi

# Disable ICMP Redirect Acceptance
    echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects

# Do not send Redirect Messages
    echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects

# Enable bad error message protection
    echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses

# Enable broadcast echo protection
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Disable source-routed packets
    echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

# Log spoofed packets, source-routed packets, and redirect packets
    #echo 1 > /proc/sys/net/ipv4/conf/all/log_martians
}

firewall_init() {
    echo "0" > /proc/sys/net/ipv4/ip_forward
    echo "flush old rules"
    $IPT_CMD -F $SW_VERB
    $IPT_CMD -t nat -F $SW_VERB
    $IPT_CMD -t mangle -F $SW_VERB
    $IPT_CMD -t raw -F $SW_VERB

    $IPT_CMD -X $SW_VERB
    $IPT_CMD -t nat -X $SW_VERB
    $IPT_CMD -t mangle -X $SW_VERB
    $IPT_CMD -t raw -X $SW_VERB

    $IPT_CMD -Z $SW_VERB
    $IPT_CMD -t nat -Z $SW_VERB
    $IPT_CMD -t mangle -Z $SW_VERB
    $IPT_CMD -t raw -Z $SW_VERB
}

firewall_policies() {
    echo "set default policy"
    $IPT_CMD -P INPUT $1 $SW_VERB
    $IPT_CMD -P OUTPUT $1 $SW_VERB
    $IPT_CMD -P FORWARD $1 $SW_VERB
}

chain_creation() {
   echo "create userchain"
   $IPT_CMD -N IN_SPOOF $SW_VERB
   $IPT_CMD -N OUT_SPOOF $SW_VERB
   $IPT_CMD -N TCP_CHECKS $SW_VERB
   $IPT_CMD -N WAN_SERVS $SW_VERB
   $IPT_CMD -N IN_ICMP $SW_VERB
   $IPT_CMD -N OUT_ICMP $SW_VERB

#spoof on loopback (IN)
   $IPT_CMD -A IN_SPOOF -i lo ! -s 127.0.0.1 -j DROP $SW_VERB
   $IPT_CMD -A IN_SPOOF -i lo ! -d 127.0.0.1 -j DROP $SW_VERB

#  $IPT_CMD -A IN_SPOOF -i $IF_WLAN -s 10.0.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_WLAN -s 127.0.0.0/8 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_WLAN -s 192.168.0.0/16 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_WLAN -s 192.168.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_WLAN -s 192.168.1.2/24 -j DROP $SW_VERB
#---------------------------------------------------------------------   
#  $IPT_CMD -A IN_SPOOF -i $IF_INT -s 10.0.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_INT -s 127.0.0.0/8 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_INT -s 192.168.0.0/16 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_INT -s 192.168.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A IN_SPOOF -i $IF_INT -s 192.168.1.2/24 -j DROP $SW_VERB

#spoof on loopback (OUT)
   $IPT_CMD -A OUT_SPOOF -o lo ! -s 127.0.0.1 -j DROP $SW_VERB
   $IPT_CMD -A OUT_SPOOF -o lo ! -d 127.0.0.1 -j DROP $SW_VERB

#  $IPT_CMD -A OUT_SPOOF -o $IF_WLAN -s 10.0.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WLAN -s 127.0.0.0/8 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WLAN -s 192.168.0.0/16 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WLAN -s 192.168.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WLAN -s 192.168.1.0/24 -j DROP $SW_VERB
#---------------------------------------------------------------------     
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -s 10.0.0.0/24 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -s 127.0.0.0/8 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -s 192.168.0.0/16 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -s 192.168.0.0/24 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -s 192.168.1.0/24 -j DROP $SW_VERB
#---------------------------------------------------------------------   
#  $IPT_CMD -A OUT_SPOOF -o $IF_WAN -d 10.0.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WAN -d 127.0.0.0/8 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WAN -d 192.168.0.0/16 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WAN -d 192.168.0.0/24 -j DROP $SW_VERB
#  $IPT_CMD -A OUT_SPOOF -o $IF_WAN -d 192.168.1.0/24 -j DROP $SW_VERB
#---------------------------------------------------------------------   
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -d 10.0.0.0/24 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -d 127.0.0.0/8 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -d 192.168.0.0/16 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -d 192.168.0.0/24 -j DROP $SW_VERB
#   $IPT_CMD -A OUT_SPOOF -o $IF_INT -d 192.168.1.0/24 -j DROP $SW_VERB
   
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags ALL NONE -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags FIN,ACK FIN -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags ACK,PSH PSH -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags ACK,URG URG -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags SYN,RST SYN,RST -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags FIN,RST FIN,RST -j DROP $SW_VERB
   $IPT_CMD -A TCP_CHECKS -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP $SW_VERB
}


easy_rule() {
# Allow loopback traffic
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# Allow packets of established connections and those related to them
$IPT -A INPUT -i $EXT_IF -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow all outgoing packets
$IPT -A OUTPUT -o $EXT_IF -j ACCEPT
}


case "$1" in
   start)
      echo "Configuring firewall... "
      firewall_init
      firewall_policies DROP
      chain_creation
      sec_icmp
      input_services
      main_rules
      sharing_rules
      port_forwarding
      closing_rules
      enable_logging
   ;;
   stop)
      echo "Resetting firewall... "
      firewall_init
      firewall_policies ACCEPT
   ;;
   status)
      echo "Status..."
      $IPT_CMD -L -n -v --line-numbers > /tmp/firewall.out
      more >> /tmp/firewall.out
      $IPT_CMD -t nat -L -n -v --line-numbers >> /tmp/firewall.out
      cat /tmp/firewall.out | less
      rm /tmp/firewall.out
      #watch --interval 0 'iptables -nvL | grep -v "0 0"'
   ;;
   *)
      echo "Usage:  `basename $0`  start|stop|status"
      exit 1
   ;;
esac
