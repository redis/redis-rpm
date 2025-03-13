#!/bin/bash

# Check if SELinux is enabled and the necessary commands are available
if [ "$(getenforce 2>/dev/null)" = "Enforcing" ] && command -v semanage &>/dev/null && command -v restorecon &>/dev/null; then
    #
    # SELinux configuration
    # Note: These commands set the correct file contexts for Redis files
    #
    # SELinux is enforcing and commands are available, proceed with context setup
    echo "Setting up SELinux contexts for Redis..."

    # Library files
    semanage fcontext -a -t lib_t "/usr/lib/redis(/.*)?"
    semanage fcontext -a -t lib_t "/usr/lib/redis/modules(/.*)?"

    # Binary files
    semanage fcontext -a -t bin_t "/usr/bin/redis(/.*)?"

    # Log files
    semanage fcontext -a -t var_log_t "/var/log/redis(/.*)?"
    semanage fcontext -a -t var_log_t "/var/log/redis/redis-server.log"
    semanage fcontext -a -t var_log_t "/var/log/redis/redis-sentinel.log"

    # Configuration files
    semanage fcontext -a -t etc_t "/etc/redis(/.*)?"
    semanage fcontext -a -t etc_t "/etc/redis/redis.conf"
    semanage fcontext -a -t etc_t "/etc/redis/sentinel.conf"

    # Runtime files - Using /var/run instead of /run due to SELinux equivalency rules
    semanage fcontext -a -t var_run_t "/var/run/redis(/.*)?"
    semanage fcontext -a -t var_run_t "/var/run/redis/redis-server.pid"

    # Data directory
    semanage fcontext -a -t var_lib_t "/var/lib/redis(/.*)?"

    # Service file - Systemd unit file
    semanage fcontext -a -t systemd_unit_file_t "/usr/lib/systemd/system/redis.service"

    #
    # Apply all SELinux contexts
    # The -v flag makes the commands verbose
    # The -R flag applies recursively to directories
    #

    restorecon -Rv /usr/lib/redis
    restorecon -Rv /usr/bin/redis*
    restorecon -Rv /var/log/redis
    restorecon -Rv /etc/redis
    restorecon -Rv /var/run/redis
    restorecon -Rv /var/lib/redis
    restorecon -v /usr/lib/systemd/system/redis.service
else
    echo "SELinux is not enforcing or semanage/restorecon commands are not available. Skipping SELinux setup."
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
