# Redis CE with Modules - RPM Packaging

This repository provides tools and configurations to build and package Redis Community Edition with additional modules as RPM packages for RHEL-compatible distributions.

## Features

- Redis 8.0 with popular modules included:
  - RedisBloom
  - RediSearch
  - RedisTimeSeries
  - ReJSON
- Multi-architecture support (amd64/arm64)
- RPM packages for Rocky Linux 8/9 (compatible with RHEL 8/9, AlmaLinux 8/9)

## Prerequisites

### For Building RPMs

- Docker (for container-based builds)
- Go 1.21+ (for nfpm)
- Git

### For Installing RPMs

- Rocky Linux 8/9, RHEL 8/9, AlmaLinux 8/9, or other compatible distributions
- Systemd

## Installation

### From Pre-built Packages

1. Install the package:

```bash
sudo dnf install -y ./redis-*.rpm
```

2. Enable and start Redis:

```bash
sudo systemctl enable redis
sudo systemctl start redis
```

3. Verify the installation:

```bash
redis-cli ping
redis-cli info modules  # Should show all included modules
```

### Using GitHub Actions

The repository includes GitHub Actions workflows to automate the build process. To use them:

1. Fork this repository
2. Enable GitHub Actions in your fork
3. Set up any required secrets (if needed)
4. Push a tag in the format `v*` to trigger a release build

## Project Structure

```
.
├── README.md                    # This file
├── configs/                     # Configuration files
│   ├── redis.conf               # Default Redis configuration
│   ├── redis.service            # Systemd service file
│   └── sentinel.conf            # Redis Sentinel configuration
├── dockerfiles/                 # Docker build environments
│   ├── Dockerfile.rockylinux8   # Rocky Linux 8 build environment
│   └── Dockerfile.rockylinux9   # Rocky Linux 9 build environment
├── scripts/                     # RPM package scripts
│   ├── postinstall.sh           # Post-install configuration
│   ├── postremove.sh            # Post-removal cleanup
│   ├── preinstall.sh            # Pre-installation setup
│   └── preremove.sh             # Pre-removal preparation
└── templates/                   # Build templates
    └── nfpm.yaml.tpl            # nfpm configuration template
```

## Configuration

After installation, Redis configuration files are located in `/etc/redis/`:

- Main Redis configuration: `/etc/redis/redis.conf`
- Sentinel configuration: `/etc/redis/sentinel.conf`

Log files are stored in `/var/log/redis/`, and data is stored in `/var/lib/redis/`.

To customize Redis configuration:

1. Edit the configuration file:

```bash
sudo vi /etc/redis/redis.conf
```

2. Restart Redis to apply changes:

```bash
sudo systemctl restart redis
```
