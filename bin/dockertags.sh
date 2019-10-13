#!/bin/bash

if [ $# -lt 1 ]; then
cat << HELP
dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE: 
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache
HELP
exit
fi

IMAGE="$1"
TAGS=$(wget -q https://registry.hub.docker.com/v1/repositories/${IMAGE}/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}')

if [ -n "$2" ]; then
    TAGS=$(echo "${TAGS}" | grep "$2")
fi

echo "${TAGS}"
