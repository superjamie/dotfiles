#!/bin/bash
# list installed kernels on detected distros so you can erase old ones

# /etc/os-release is present on Ubu 18.04 and CentOS 7, but not on CentOS 6
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        sudo apt list --installed 2>/dev/null | awk -F'/' '/^linux.*(header|image|module)/{print $1}' | sort
    elif [[ "$ID" == "centos" || "$ID" == "rhel" || "$ID" == "fedora" ]]; then
        sudo rpm -qa | egrep "^kernel" | sort
    fi  
fi
