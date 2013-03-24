#!/bin/bash

IPT_CMD="/usr/sbin/iptables"
SW_VERB="-v"
IF_INT="eth0"
IF_WLAN="wlan0"

firewall_init() {
   echo "0" > /proc/sys/net/ipv4/ip_forward
   $IPT_CMD -F $SW_VERB
   $IPT_CMD -t nat -F $SW_VERB
   $IPT_CMD -t mangle -F $SW_VERB
   $IPT_CMD -X $SW_VERB
   $IPT_CMD -t nat -X $SW_VERB
   $IPT_CMD -t mangle -X $SW_VERB
}

firewall_policies() {
   $IPT_CMD -P INPUT $1 $SW_VERB
   $IPT_CMD -P OUTPUT $1 $SW_VERB
   $IPT_CMD -P FORWARD $1 $SW_VERB
}

chain_creation() {
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


sec_icmp() {
	echo "sec_icmp"
#  $IPT_CMD -A IN_ICMP -i lo -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A IN_ICMP -i $IF_LAN -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A IN_ICMP -i $IF_WAN -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB
#  $IPT_CMD -A IN_ICMP -i $IF_INT -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB
#  $IPT_CMD -A IN_ICMP -p icmp -j DROP $SW_VERB
#  $IPT_CMD -A OUT_ICMP -o lo -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUT_ICMP -o $IF_LAN -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUT_ICMP -o $IF_WAN -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUT_ICMP -o $IF_INT -p icmp -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUT_ICMP -p icmp -j DROP $SW_VERB
}


input_services() {
   echo "input services"

#   $IPT_CMD -A WAN_SERVS -p tcp --dport 80 -j ACCEPT $SW_VERB      # HTTP
#   $IPT_CMD -A WAN_SERVS -p tcp --dport 21 -j ACCEPT $SW_VERB      # FTP

#  $IPT_CMD -A WAN_SERVS -p tcp --dport 22 -j ACCEPT $SW_VERB      # SSH
#  $IPT_CMD -A WAN_SERVS -p tcp --dport 50000:55000 -j ACCEPT $SW_VERB   # FTP Passive
#  $IPT_CMD -A WAN_SERVS -p tcp --dport 6667 -j ACCEPT $SW_VERB      # IRCd
#  $IPT_CMD -A WAN_SERVS -p tcp --dport 30000:30010 -j ACCEPT $SW_VERB   # DCC XChat
#  $IPT_CMD -A WAN_SERVS -p udp --dport 27960 -j ACCEPT $SW_VERB      # UrT Server
#  $IPT_CMD -A WAN_SERVS -p tcp --dport 20000 -j ACCEPT $SW_VERB      # aMule TCP
#  $IPT_CMD -A WAN_SERVS -p udp --dport 20001 -j ACCEPT $SW_VERB      # aMule UDP advanced
#  $IPT_CMD -A WAN_SERVS -p udp --dport 20003 -j ACCEPT $SW_VERB      # aMule UDP
}

main_rules() {
   $IPT_CMD -A INPUT -j IN_SPOOF $SW_VERB
   $IPT_CMD -A INPUT -j TCP_CHECKS $SW_VERB
   $IPT_CMD -A INPUT -i lo -j ACCEPT $SW_VERB

#  $IPT_CMD -A INPUT -i $IF_LAN -j ACCEPT $SW_VERB
#  $IPT_CMD -A INPUT -i $IF_WAN -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB

   $IPT_CMD -A INPUT -i $IF_INT -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB
   $IPT_CMD -A INPUT -i $IF_WLAN -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB

#    $IPT_CMD -A INPUT -i $IF_INT -p tcp --dport 80 -j ACCEPT $SW_VERB   
#    $IPT_CMD -A INPUT -i $IF_WLAN -p tcp --dport 80 -j ACCEPT $SW_VERB

#    $IPT_CMD -A INPUT -i $IF_INT -p tcp --dport 53 -j ACCEPT $SW_VERB
#    $IPT_CMD -A INPUT -i $IF_WLAN -p tcp --dport 53 -j ACCEPT $SW_VERB

#    $IPT_CMD -A INPUT -i $IF_INT -p tcp --sport 80 -j ACCEPT $SW_VERB
#    $IPT_CMD -A INPUT -i $IF_WLAN -p tcp --sport 80 -j ACCEPT $SW_VERB

#    $IPT_CMD -A INPUT -i $IF_INT -p tcp --sport 53 -j ACCEPT $SW_VERB
#    $IPT_CMD -A INPUT -i $IF_WLAN -p tcp --sport 53 -j ACCEPT $SW_VERB


#  $IPT_CMD -A INPUT -i $IF_WAN -j WAN_SERVS $SW_VERB

   $IPT_CMD -A INPUT -i $IF_INT -j WAN_SERVS $SW_VERB
   $IPT_CMD -A INPUT -i $IF_WLAN -j WAN_SERVS $SW_VERB

   $IPT_CMD -A OUTPUT -j OUT_SPOOF $SW_VERB
   $IPT_CMD -A OUTPUT -j TCP_CHECKS $SW_VERB
   $IPT_CMD -A OUTPUT -o lo -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUTPUT -o $IF_LAN -j ACCEPT $SW_VERB
#  $IPT_CMD -A OUTPUT -o $IF_WAN -j ACCEPT $SW_VERB

   $IPT_CMD -A OUTPUT -o $IF_INT -j ACCEPT $SW_VERB
   $IPT_CMD -A OUTPUT -o $IF_WLAN -j ACCEPT $SW_VERB
}

sharing_rules() {
	echo "Sharing Rules"
#   $IPT_CMD -A FORWARD -i $IF_LAN -o $IF_WAN -s 192.168.0.0/24 -j ACCEPT $SW_VERB
#   $IPT_CMD -A FORWARD -i $IF_WAN -o $IF_LAN -d 192.168.0.0/24 -m state --state ESTABLISHED,RELATED -j ACCEPT $SW_VERB
#   $IPT_CMD -t nat -A POSTROUTING -o $IF_WAN -d ! 192.168.0.0/24 -j MASQUERADE $SW_VERB
#   echo "1" > /proc/sys/net/ipv4/ip_forward
}

port_forwarding() {
	echo "port forwarding"
#   $IPT_CMD -t nat -A PREROUTING -i $IF_WAN -p tcp --dport 6667 -j DNAT --to 192.168.0.5:6667 $SW_VERB
#   $IPT_CMD -A FORWARD -i $IF_WAN -o $IF_LAN -d 192.168.0.5 -p tcp --dport 6667 -j ACCEPT $SW_VERB
}

closing_rules() {
   echo "Closing Rules - DROP"
   $IPT_CMD -A INPUT -j DROP $SW_VERB
   $IPT_CMD -A OUTPUT -j DROP $SW_VERB
   $IPT_CMD -A FORWARD -j DROP $SW_VERB
   echo "Zeroing"
   $IPT_CMD -Z $SW_VERB
   $IPT_CMD -t nat -Z $SW_VERB
   $IPT_CMD -t mangle -Z $SW_VERB
}

enable_logging() {
	#---------------------------------------------------------------
	# Log and drop all other packets to file /var/log/messages
	# Without this we could be crawling around in the dark
	#---------------------------------------------------------------
    echo "Enable Logging"
	$IPT_CMD -A OUTPUT -j LOG
	$IPT_CMD -A INPUT -j LOG
	$IPT_CMD -A FORWARD -j LOG
 
#	$IPT_CMD -A OUTPUT -j DROP
#	$IPT_CMD -A INPUT -j DROP
#	$IPT_CMD -A FORWARD -j DROP
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
