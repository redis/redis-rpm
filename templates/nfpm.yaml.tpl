name: "Redis"
arch: "${ARCH}"
platform: linux
version: "${VERSION}"
section: "default"
priority: "extra"
maintainer: "Redis Labs <redis@redis.io>"
description: "Redis is an in-memory database that persists on disk. The data model is key-value, but many different kind of values are supported: Strings, Lists, Sets, Sorted Sets, Hashes, Streams, HyperLogLogs, Bitmaps."
homepage: "https://redis.io/"

depends:
  - policycoreutils # For restorecon
  - policycoreutils-python-utils # For semanage

contents:
  # Runtime directories
  - dst: /var/lib/redis
    type: dir
    file_info:
      mode: 0750
      owner: redis
      group: redis
  - dst: /var/log/redis
    type: dir
    file_info:
      mode: 0750
      owner: redis
      group: redis
  - dst: /run/redis
    type: dir
    file_info:
      mode: 0750
      owner: redis
      group: redis
  - dst: /run/redis/redis-server.pid
    type: ghost
    file_info:
      mode: 0644
      owner: redis
      group: redis

  # Redis libraries and modules
  - dst: /usr/lib/redis
    type: dir
    file_info:
      mode: 0755
      owner: redis
      group: redis
  - dst: /usr/lib/redis/modules
    type: dir
    file_info:
      mode: 0755
      owner: redis
      group: redis
  - src: /usr/local/lib/redis/*
    dst: /usr/lib/redis/
    file_info:
      mode: 0755
      owner: redis
      group: redis
  - src: /usr/local/lib/redis/modules/*
    dst: /usr/lib/redis/modules/
    file_info:
      mode: 0755
      owner: redis
      group: redis

  # System binaries
  - src: /usr/local/bin/redis*
    dst: /usr/bin/
    file_info:
      mode: 0755
      owner: root
      group: root

  # Configuration files and directories
  - dst: /etc/redis
    type: dir
    file_info:
      mode: 0750
      owner: redis
      group: redis
  - src: ./configs/redis.conf
    dst: /etc/redis/redis.conf
    type: config|noreplace
    file_info:
      mode: 0640
      owner: redis
      group: redis
  - src: ./configs/sentinel.conf
    dst: /etc/redis/sentinel.conf
    type: config|noreplace
    file_info:
      mode: 0640
      owner: redis
      group: redis

  # Systemd service file
  - src: ./configs/redis.service
    dst: /usr/lib/systemd/system/redis.service
    type: config
    file_info:
      mode: 0644
      owner: root
      group: root

  # Log files
  - dst: /var/log/redis/redis-sentinel.log
    type: ghost
    file_info:
      mode: 0640
      owner: redis
      group: redis
  - dst: /var/log/redis/redis-server.log
    type: ghost
    file_info:
      mode: 0640
      owner: redis
      group: redis

scripts:
  preinstall: ./scripts/preinstall.sh
  postinstall: ./scripts/postinstall.sh
  preremove: ./scripts/preremove.sh
  postremove: ./scripts/postremove.sh

rpm:
  summary: "Redis is an in-memory database that persists on disk. The data model is key-value, but many different kind of values are supported: Strings, Lists, Sets, Sorted Sets, Hashes, Streams, HyperLogLogs, Bitmaps."
  group: "Applications/Databases"
  packager: "Redis Labs <redis@redis.io>"
