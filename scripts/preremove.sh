#!/bin/bash
# Stop and disable the service
systemctl stop redis.service
systemctl disable redis.service
