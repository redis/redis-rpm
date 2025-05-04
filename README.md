This repository creates the redis-tools rpm, uploading it to our S3 RPM feed.

## Redis Open Source - Install using RPM Package Manager

To install the latest version of Redis Community Edition using RPM Package Manager, please use the following command:

1. Create the file `/etc/yum.repos.d/redis.repo` with the following contents.

  - For Rocky Linux 9 / AlmaLinux 9 / etc...
  ```ini
  [Redis]
  name=Redis
  baseurl=http://packages.redis.io/rpm/rockylinux9
  enabled=1
  gpgcheck=1
  ```
   - For Rocky Linux 8 / AlmaLinux 8 / etc...
  ```ini
  [Redis]
  name=Redis
  baseurl=http://packages.redis.io/rpm/rockylinux8
  enabled=1
  gpgcheck=1
  ```

2. Run the following commands:
```sh
curl -fsSL https://packages.redis.io/gpg > /tmp/redis.key
sudo rpm --import /tmp/redis.key
sudo yum install epel-release
sudo yum install redis-server
```

> [!TIP]
> Redis will not start automatically, nor will it start at boot time. To do this, run the following commands.
> ```sh
> sudo systemctl enable redis-server
> sudo systemctl start redis-server
> ```

## Supported Operating Systems

Redis officially tests the latest version of this distribution against the following OSes:

- CentOS 9
- Rocky Linux 8.10
- Rocky Linux 9.5
- AlmaLinux 8.10
- AlmaLinux 9.5
