#!/bin/sh
set -x -e

API_SOCKET="/tmp/firecracker.socket"

# Remove API unix socket
rm -f $API_SOCKET

# Run firecracker
./release-v1.3.3-x86_64/firecracker-v1.3.3-x86_64 --api-sock $API_SOCKET
