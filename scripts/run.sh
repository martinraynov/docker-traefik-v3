#!/bin/bash

# Requirements : you must have make installed on your system
# Usage: ./scripts/run.sh <command> or APP_NAME <command> (if installed as executable)

if [ -n "$1" ]; then
    make $1
else
    make
fi
