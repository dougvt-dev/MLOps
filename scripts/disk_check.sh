#!/usr/bin/env bash

set -euo pipefail

THRESHOLD="${THRESHOLD:-80}"

# Lấy % dung lượng đĩa đã sử dụng của thư mục hiện tại
USED=$(df -P . | awk 'NR==2 {gsub("%", "", $5); print $5}')

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if (( USED >= THRESHOLD )); then
    echo "$TIMESTAMP WARN Disk usage is ${USED}% (threshold: ${THRESHOLD}%)"
else
    echo "$TIMESTAMP INFO Disk usage is ${USED}% (threshold: ${THRESHOLD}%)"
fi