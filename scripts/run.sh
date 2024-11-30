#!/bin/bash

# Requirements : you must have make installed on your system
# Usage: Only as installed executable ! Use APP_NAME <command> (when installed as executable)

APP_PATH=$(dirname $(find -L /usr/local/bin/traefik -exec readlink -f {} +))
if [ -n "$1" ]; then
    (cd ${APP_PATH} && cd .. && ${pwd} && make $1)
else
    (cd ${APP_PATH} && cd .. && make)
fi

