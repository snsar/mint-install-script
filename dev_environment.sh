#!/bin/bash
#
# Script cài đặt tự động cho Linux Mint
# Tự động cài đặt các phần mềm và công cụ cần thiết sau khi cài đặt Linux Mint

# Màu sắc cho terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Hàm hiển thị tiêu đề
print_section() {
  echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Hàm hiển thị thông báo thành công
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Hàm hiển thị thông báo lỗi
print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Hàm hiển thị thông báo cảnh báo
print_warning() {
  echo -e "${YELLOW}! $1${NC}"
}

# Hàm xác nhận từ người dùng
confirm() {
  read -p "$1 (y/n): " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

print_section "BẮT ĐẦU CÀI ĐẶT"
echo "Vui lòng đảm bảo máy tính được kết nối internet"
echo "Script này sẽ cài đặt các phần mềm và công cụ cần thiết cho Linux Mint"


# Install SDKMAN
if confirm "Bạn có muốn cài đặt SDKMAN không?"; then
  echo "Đang cài đặt SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
  source "~/.sdkman/bin/sdkman-init.sh"
  print_success "Đã cài đặt SDKMAN"
fi


# Install Java 24
if confirm "Bạn có muốn cài đặt Java 24 không?"; then
  echo "Đang cài đặt Java 24..."
  sdk install java 24-open
  print_success "Đã cài đặt Java 24"
fi


# Install Volta (a Js package manager)
if confirm "Bạn có muốn cài đặt Volta không?"; then
  echo "Đang cài đặt Volta..."
  curl https://get.volta.sh | bash
  print_success "Đã cài đặt Volta"
fi

# Install node LTS
if confirm "Bạn có muốn cài đặt Node LTS không?"; then
  echo "Đang cài đặt Node LTS..."
  volta install node
  print_success "Đã cài đặt Node LTS"
fi

# Install lazydocker
if confirm "Bạn có muốn cài đặt Lazydocker không?"; then
  echo "Đang cài đặt Lazydocker..."
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  print_success "Đã cài đặt Lazydocker"
fi
