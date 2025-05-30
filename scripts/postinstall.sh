#!/bin/bash

export SELINUX_ERROR=
export SELINUX_ENABLED=

selinux_enabled() {
    local selinux_status
    if command -v getenforce &> /dev/null; then
        selinux_status=$(getenforce 2>/dev/null)
        if [ "$selinux_status" = "Enforcing" ] || [ "$selinux_status" = "Permissive" ]; then
            echo 1
            return 0
        fi
    fi
    return 1
}

selinux_run_command() {
    local cmd_output
    local cmd_res
    cmd_output=$("$@" 2>&1)
    cmd_res=$?
    if [ $cmd_res -ne 0 ]; then
        SELINUX_ERROR=1
        # Output the error if SELinux is enabled
        # If it's not then likely SELinux has been intentionally removed
        if [ "$SELINUX_ENABLED" = "1" ]; then
            echo "$cmd_output"
        fi
        return 1
    fi
}

setup_selinux() {
    # Install SELinux policy module if SELinux tools are available
    if command -v checkmodule &> /dev/null && command -v semodule_package &> /dev/null; then
        # Compile policy module
        selinux_run_command checkmodule \
            -M -m /usr/share/selinux/packages/redis-ce.te \
            -o /usr/share/selinux/packages/redis-ce.mod \
        || return 1

        selinux_run_command semodule_package \
            -m /usr/share/selinux/packages/redis-ce.mod \
            -o /usr/share/selinux/packages/redis-ce.pp \
            -f /usr/share/selinux/packages/redis-ce.fc \
        || return 1

        # Install or update the policy module
        selinux_run_command semodule -i /usr/share/selinux/packages/redis-ce.pp || return 1
    fi

    # Allow writing to /etc/redis/sentinel/ for redis-sentinel
    if command -v chcon &> /dev/null; then
        selinux_run_command chcon \
            -t redis_conf_t \
            '/etc/redis/sentinel' \
            '/etc/redis/sentinel/sentinel.conf' \
        || return 1
    fi
}

selinux_show_error() {
    if [ "$SELINUX_ENABLED" = "1" ]; then
        echo "Error: Unable to setup SELinux policies. See above for details."
    else
        echo "Warning: SELinux policies not configured. To enable SELinux in the future, install selinux-policy-targeted and reinstall this package."
    fi
}

SELINUX_ENABLED=$(selinux_enabled)
setup_selinux || selinux_show_error

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