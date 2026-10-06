#!/usr/bin/env bash
# setup.sh chuẩn bị môi trường dev, chạy lại bao nhiêu lần cũng được:

# kiểm tra máy đã có git, make, curl, python3 chưa; thiếu công cụ nào thì in rõ tên và cách cài (sudo apt install ...), rồi thoát với exit code 1;
# cài uv nếu chưa có, bằng lệnh curl -LsSf https://astral.sh/uv/install.sh | sh;
# cài shellcheck và tmux nếu chưa có;
# tạo các thư mục data/raw, logs, checkpoints.

set -euo pipefail

missing=()

for cmd in git make curl python3; do
  if ! command -v "$cmd" &>/dev/null; then
    missing+=("$cmd")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Thiếu các công cụ sau: ${missing[*]}"

    for cmd in "${missing[@]}"; do
        echo " - $cmd "
        echo " Cai dat: sudo apt install $cmd"
    done

    exit 1
fi

echo "Đã kiểm tra: git, make, curl, python3"

# Cài uv nếu chưa có
if command -v uv >/dev/null 2>&1; then
    echo "Đã cài uv"
else
    echo "Cài uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    export PATH="$HOME/.local/bin:$PATH"

    if ! command -v uv >/dev/null 2>&1; then
        echo "Cài uv thất bại. Vui lòng kiểm tra và cài đặt thủ công."
        exit 1
    fi
    echo "Đã cài thành công uv"
fi

# 3. Cài shellcheck nếu chưa có
if command -v shellcheck >/dev/null 2>&1; then
    echo "shellcheck đã được cài đặt."
else
    echo "Chưa có shellcheck, đang cài đặt..."
    sudo apt install -y shellcheck
fi

# 4. Cài tmux nếu chưa có
if command -v tmux >/dev/null 2>&1; then
    echo "tmux đã được cài đặt."
else
    echo "Chưa có tmux, đang cài đặt..."
    sudo apt install -y tmux
fi

# 5. Tạo các thư mục cần thiết
mkdir -p data/raw logs checkpoints

echo "Đã tạo/kiểm tra các thư mục:"
echo "  data/raw"
echo "  logs"
echo "  checkpoints"

echo "Setup hoàn tất."