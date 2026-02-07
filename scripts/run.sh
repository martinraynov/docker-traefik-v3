#!/bin/bash

# Requirements : you must have make installed on your system
# Usage: Only as installed executable ! Use APP_NAME <command> (when installed as executable)

# Get the name of the current app
APP_NAME=$(basename "$0")
# Get the origin path of the current app
APP_PATH=$(dirname $(find -L /usr/local/bin/${APP_NAME} -exec readlink -f {} +))

if [ -n "$1" ]; then
    (cd ${APP_PATH} && cd .. && make $1)
else
    (cd ${APP_PATH} && cd .. && make)
fi
