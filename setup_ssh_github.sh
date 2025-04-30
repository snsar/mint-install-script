#!/bin/bash

# 0. Load biến môi trường từ file .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ Không tìm thấy file .env!"
    exit 1
fi

# 1. Kiểm tra biến GITHUB_EMAIL
if [ -z "$GITHUB_EMAIL" ]; then
    echo "❌ GITHUB_EMAIL không được đặt trong file .env"
    exit 1
fi

# 2. Tạo SSH key nếu chưa có
SSH_KEY=~/.ssh/id_ed25519
if [ -f "$SSH_KEY" ]; then
    echo "✅ SSH key đã tồn tại: $SSH_KEY"
else
    echo "🔑 Đang tạo SSH key mới..."
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY" -N ""
fi

# 3. Thêm key vào ssh-agent
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

# 4. Hiển thị public key để copy
echo "📋 SSH public key của bạn (copy để dán vào GitHub):"
echo "------------------------------------------------------"
cat "${SSH_KEY}.pub"
echo "------------------------------------------------------"

# 5. Mở trang thêm SSH key trên GitHub
xdg-open https://github.com/settings/ssh/new

# 6. Gợi ý kiểm tra kết nối sau khi thêm
echo "✅ Sau khi thêm key, hãy chạy: ssh -T git@github.com"
