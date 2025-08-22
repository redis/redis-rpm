#!/bin/bash

if [ "$1" = "0" ]; then
    # Package removal, not an upgrade
    systemctl stop redis.service 2>&1 || :
    systemctl disable redis.service 2>&1 || :
fi
