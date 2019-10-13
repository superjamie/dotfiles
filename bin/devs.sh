#!/bin/bash
# lists block devices
# so you don't erase the wrong one when managing usb drive or sdcard

lsblk | awk '/sd[a-z][^0-9]/ {print $1 " " $4}'
