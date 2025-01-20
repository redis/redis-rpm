#!/bin/bash
# Create the redis user and group
getent group redis >/dev/null || groupadd -r redis
getent passwd redis >/dev/null || useradd -r -g redis -s /sbin/nologin -c "Redis Server" redis
