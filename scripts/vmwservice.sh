#!/bin/bash

case "$1" in
   start)
	chmod +x /etc/rc.d/init.d/vmware
	/etc/rc.d/init.d/vmware start
   ;;
   stop)
	/etc/rc.d/init.d/vmware stop
	chmod -x /etc/rc.d/init.d/vmware
   ;;
   *)
      echo "Usage:  `basename $0`  start|stop"
      exit 1
   ;;
esac
