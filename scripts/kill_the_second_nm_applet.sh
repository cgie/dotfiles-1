#!/bin/bash
LINES= kill -9 `ps aux | grep nm-applet | sed \$d | wc -l awk '{ print $2 }' |  sed -n 2p`
kill -9 `ps aux | grep nm-applet | awk '{ print $2 }' |  sed -n 2p`
