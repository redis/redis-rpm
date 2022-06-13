#!/bin/bash

VERSION=$1
OSNICK=$2
ARCH=$3

if [ -z ${ARCH} ]; then
    echo "Usage: ${0} {version} {osnick} {arch}"
    echo "eg: ${0} 7.0.0 bionic x86_64"
    exit 1
fi
rm -rf build *.rpm
mkdir -p build/usr/bin
cp deps/redis*/* build/usr/bin
chmod 0755 build/usr/bin/*
set -x
fpm \
    -s dir \
    -C build \
    -n redis-tools \
    --version ${VERSION} \
    --maintainer "oss@redis.com" \
    --license "BSD-3-Clause" \
    --url "https://redis.io" \
    --vendor "Redis Inc" \
    --architecture ${ARCH} \
    --provides redis-tools \
    --rpm-user root \
    --rpm-group root \
    --rpm-dist ${OSNICK} -t rpm
