#!/bin/bash

for DIR in bundle*; do
    cd "$DIR"
    for PLUGIN in *; do
        echo "=== Updating $DIR/$PLUGIN ==="
        cd "$PLUGIN"
        git checkout master
        git pull
        cd ..
    done
    cd ..
done
