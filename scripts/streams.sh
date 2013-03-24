#!/bin/bash

case "$1" in
   list)
      echo "List... "
	echo "01='[chill] http://streamer-mtc-aa01.somafm.com:80/stream/1018'"
	echo "02='[elect] http://www.protonradio.com:8000'"
	echo "03='[downt] http://streamer-ntc-aa01.somafm.com:80/stream/1021'"
	echo "04='[chill] http://scfire-ntc-aa01.stream.aol.com:80/stream/1035'"
	echo "05='[elect] http://205.188.215.230:8012'"
	echo "06='[elect] http://205.188.215.225:8004'"
	echo "07='[psych] http://91.121.158.8:8000'"
	echo "08='[house] http://stream.mth-house.de:8500/'"
	echo "09='[m2oit] http://mp3.m2o.it'"
	echo "10='[space] http://205.188.215.227:8014'"
	echo "11='[drone] http://streamer-dtc-aa01.somafm.com:80/stream/1032'"
	echo "12='[] http://81.23.249.40:8000'"
	echo "13='[ambie] http://electro.mthn.net:8400'"
	echo "14='[house] http://scfire-mtc-aa06.stream.aol.com:80/stream/1007'"
        echo "15='[techn] http://78.159.104.181:80'"
        echo "16='[minim] http://91.121.120.47:4100'"
        echo "17='[deeph] http://91.121.10.128:8128'"
        echo "18='[elect] http://72.26.204.18:6354'"
        echo "19='[minim] http://94.232.114.240:6244'"
        echo "20='[] http://91.121.120.47:4100'"
        echo "21='[techh] http://72.26.204.18:6354'"
	echo "22='[indie] http://78.129.146.165:8072'"
	echo "23='[minim] http://91.121.120.47:4100'"
	echo "24='[triph] http://87.98.148.145:80'"
	echo "25='[tranc] http://scfire-mtc-aa05.stream.aol.com:80/stream/1003'"
	echo "26='[jazzy] http://ice.somafm.com/sonicuniverse'"
   ;;

   01)
	mplayer http://streamer-mtc-aa01.somafm.com:80/stream/1018
   ;;
   02)
	mplayer http://www.protonradio.com:8000
   ;;
   03)
	mplayer http://streamer-ntc-aa01.somafm.com:80/stream/1021
   ;;
   04)
	mplayer http://scfire-ntc-aa01.stream.aol.com:80/stream/1035
   ;;
   05)
	mplayer http://205.188.215.230:8012
   ;;
   06)
	mplayer http://205.188.215.225:8004
   ;;
   07)
	mplayer http://91.121.158.8:8000
   ;;
   08)
	mplayer http://stream.mth-house.de:8500/
   ;;
   09)
	mplayer http://mp3.m2o.it
   ;;
   10)
	mplayer http://205.188.215.227:8014
   ;;
   11)
	mplayer http://streamer-dtc-aa01.somafm.com:80/stream/1032
   ;;
   12)
	mplayer http://81.23.249.40:8000
   ;;
   13)
	mplayer http://electro.mthn.net:8400
   ;;
   14)
	mplayer http://scfire-mtc-aa06.stream.aol.com:80/stream/1007
   ;;
   15)
	mplayer http://78.159.104.181:80
   ;;
   16)
	 mplayer http://91.121.120.47:4100 
   ;;
   17)
	mplayer http://91.121.10.128:8128 
   ;;
   18)
	 mplayer http://72.26.204.18:6354
   ;;
   19)
	mplayer http://94.232.114.240:6244
   ;;
   20)
	mplayer http://66.135.35.201:8000
   ;;
   21)
        mplayer http://72.26.204.18:6354
   ;;
   22)
	mplayer http://78.129.146.165:8072
   ;;
   23)
	mplayer http://91.121.120.47:4100
   ;;
   24)
	mplayer http://87.98.148.145:80
   ;;
   25)
	mplayer http://scfire-mtc-aa05.stream.aol.com:80/stream/1003
   ;;
   26)
	mplayer http://ice.somafm.com/sonicuniverse
   ;;
   *)
      echo "Usage:  `basename $0`  list|01-26"
      exit 1
   ;;
esac
