#!/bin/bash

arch=$(uname -m)
nodeArch=""

nodeVersion=v6.12.3

if [[ "$arch" == "x86_64" ]]; then
    nodeArch="x64"
elif [[ "$arch" == "i686" ]]; then
    nodeArch="x86"
elif [[ "$arch" == "i386" ]]; then
    nodeArch="x86"
elif [[ "$arch" == "aarch64" ]]; then
    nodeArch="arm64"
else
    nodeArch=$arch
fi

wget -O - https://nodejs.org/dist/${nodeVersion}/node-${nodeVersion}-linux-${nodeArch}.tar.gz | gzip -d > /tmp/nodejs.tar
tar --strip-components=1 -xf /tmp/nodejs.tar -C /usr
rm -f /tmp/nodejs.tar

