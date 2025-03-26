#!/bin/bash

# Install SELinux policy module if SELinux is enforcing
if command -v checkmodule &> /dev/null && command -v semodule_package &> /dev/null; then
    # Compile policy module
    checkmodule -M -m /usr/share/selinux/packages/redis-ce.te -o /usr/share/selinux/packages/redis-ce.mod
    semodule_package -m /usr/share/selinux/packages/redis-ce.mod -o /usr/share/selinux/packages/redis-ce.pp

    # Install or update the policy module
    semodule -i /usr/share/selinux/packages/redis-ce.pp
fi

# Allow writing to /etc/redis/sentinel/ for redis-sentinel
if command -v semanage &> /dev/null; then
    semanage fcontext -a -t redis_conf_t '/etc/redis/sentinel'
    restorecon '/etc/redis/sentinel'
fi

#
# Handle service setup
# $1 will be 1 for initial install and 2 for upgrade
#

if [ "$1" = "1" ]; then
    # This is a fresh install
    systemctl daemon-reload >/dev/null 2>&1 || :
    systemctl enable redis.service >/dev/null 2>&1 || :
elif [ "$1" = "2" ]; then
    # This is an upgrade
    systemctl daemon-reload >/dev/null 2>&1 || :
fi
