#!/usr/bin/env bash
# sysinfo.sh in thông tin máy theo dạng bảng gọn:

# CPU: tên CPU và số core (nproc);
# RAM: tổng dung lượng và phần đã dùng;
# đĩa: dung lượng còn trống của thư mục repo;
# GPU: tên, VRAM, % đang dùng; nếu máy không có GPU thì in GPU: không có (chạy CPU) và vẫn thoát với exit code 0.

set -euo pipefail

echo "=========================================="
echo "              SYSTEM INFO"
echo "=========================================="

# CPU
CPU_NAME=$(lscpu | awk -F: '/Model name/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')
CPU_CORES=$(nproc)

# RAM
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')

# Disk
DISK_FREE=$(df -h )
# GPU
echo "CPU       : $CPU_NAME"
echo "Core      : $CPU_CORES"
echo "RAM       : $RAM_USED / $RAM_TOTAL"
echo "Disk free : $DISK_FREE"

if command -v nvidia-smi >/dev/null 2>&1; then
    GPU_INFO=$(nvidia-smi \
        --query-gpu=name,memory.total,memory.used,utilization.gpu \
        --format=csv,noheader,nounits 2>/dev/null || true)

    if [[ -n "$GPU_INFO" ]]; then
        GPU_NAME=$(echo "$GPU_INFO" | awk -F, '{print $1}')
        GPU_VRAM_TOTAL=$(echo "$GPU_INFO" | awk -F, '{print $2}')
        GPU_VRAM_USED=$(echo "$GPU_INFO" | awk -F, '{print $3}')
        GPU_UTIL=$(echo "$GPU_INFO" | awk -F, '{print $4}')

        echo "GPU       : $GPU_NAME"
        echo "VRAM      : ${GPU_VRAM_USED} / ${GPU_VRAM_TOTAL} MiB"
        echo "Usage     : ${GPU_UTIL}%"
        
        # while IFS=',' read -r name vram_total vram_used utilization; do
        #     name=$(echo "$name" | xargs)
        #     vram_total=$(echo "$vram_total" | xargs)
        #     vram_used=$(echo "$vram_used" | xargs)
        #     utilization=$(echo "$utilization" | xargs)

        #     echo "  Name    : $name"
        #     echo "  VRAM    : ${vram_used} / ${vram_total} MiB" 
        #     echo "  Usage   : ${utilization}%"
        # done <<< "$GPU_INFO"
    else
        echo "GPU       : không có (chạy CPU)"
    fi
else
    echo "GPU       : không có (chạy CPU)"
fi

echo "========="