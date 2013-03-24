#!/bin/sh
rm /home/alpha/Documents/systemscreenshot/txt/*.txt
ls -la sources/ > /home/alpha/Documents/systemscreenshot/txt/sources.txt
ls -la sources/slackypackages/ > /home/alpha/Documents/systemscreenshot/txt/slackypack.txt
ls -la /var/log/packages/ > /home/alpha/Documents/systemscreenshot/txt/packages.txt
ls -la /usr/local > /home/alpha/Documents/systemscreenshot/txt/usrlocal.txt
#ls -la .ISO/ > /home/alpha/Documents/systemscreenshot/txt/iso.txt
#ls -laR .ZEN > /home/alpha/Documents/systemscreenshot/txt/zen.txt
ls -laR /home/alpha/ > /home/alpha/Documents/systemscreenshot/txt/alpha.txt
echo done!
