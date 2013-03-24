#!/bin/sh
echo 6 > /sys/class/backlight/acpi_video0/brightness;
sh /root/tables.sh
gem server &
exit;

