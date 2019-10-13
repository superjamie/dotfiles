#!/bin/bash
# list installed kernels on ubuntu so you can erase old ones

sudo apt list --installed 2>/dev/null | awk -F'/' '/^linux.*(header|image|module)/{print $1}' | sort
