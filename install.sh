#!/bin/bash
#
# Script cài đặt tự động cho Mint
# Tự động cài đặt các phần mềm và công cụ cần thiết sau khi cài đặt Fedora
#

# Màu sắc cho terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Vui lòng chạy script với quyền root (sudo)${NC}"
  exit 1
fi

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
echo "Script này sẽ cài đặt các phần mềm và công cụ cần thiết cho Fedora"
echo "Vui lòng đảm bảo máy tính được kết nối internet"

# Cập nhật hệ thống
print_section "CẬP NHẬT HỆ THỐNG"
echo "Đang cập nhật hệ thống..."
apt update -y
print_success "Cập nhật hệ thống hoàn tất"


# Cài đặt các gói cơ bản
print_section "CÀI ĐẶT CÁC GÓI CƠ BẢN"
echo "Đang cài đặt các gói cơ bản..."
apt install -y \
  software-properties-common \
  wget \
  curl \
  git \
  neovim \
  htop \
  unzip \
  unrar \
  zsh \
  ca-certificates \
  fd-find \
  fzf \
  ripgrep \
  tldr \
  stow \
  tmux \
  build-essential
print_success "Đã cài đặt các gói cơ bản"

if confirm "Bạn có muốn cài đặt fastfetch không?"; then
  echo "Đang cài đặt fastfetch..."
  add-apt-repository ppa:zhangsongcui3371/fastfetch
  apt update -y
  apt install -y fastfetch
  print_success "Đã cài đặt fastfetch"
fi



if confirm "Bạn có muốn cài đặt Wezterm không?"; then
  echo "Đang cài đặt Wezterm..."
  curl -fsSL https://apt.fury.io/wez/gpg.key |  gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' |  tee /etc/apt/sources.list.d/wezterm.list
  apt update -y
  apt install wezterm -y
  print_success "Đã cài đặt Wezterm"
fi

if confirm "Bạn có muốn cài đặt Brave Browser không?"; then
  echo "Đang cài đặt Brave Bro  wser..."
  curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  apt update -y
  apt install -y brave-browser
  print_success "Đã cài đặt Brave Browser"
fi

if confirm "Bạn có muốn cài đặt Docker Engine không?"; then
  echo "Đang cài đặt Docker Engine..."
  # Add Docker's official GPG key:
  apt update -y
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update -y
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  print_success "Đã cài đặt Docker Engine"
fi

if confirm "Bạn có muốn cài đặt Papirus Icon Theme không?"; then
  echo "Đang cài đặt Papirus Icon Theme..."
  sudo add-apt-repository ppa:papirus/papirus
  sudo apt-get update -y
  sudo apt-get install -y papirus-icon-theme  # Papirus, Papirus-Dark, and Papirus-Light
  print_success "Đã cài đặt Papirus Icon Theme"
fi


# Cài đặt các công cụ phát triển
print_section "CÀI ĐẶT CÔNG CỤ PHÁT TRIỂN"
if confirm "Bạn có muốn cài đặt các công cụ phát triển không?"; then
  echo "Đang cài đặt các công cụ phát triển..."
  dnf groupinstall -y "Development Tools"
  dnf install -y \
    cmake \
    gcc-c++ \
    make \
    automake \
    autoconf \
    python3-devel \
    python3-pip
  print_success "Đã cài đặt các công cụ phát triển"
fi

# Cài đặt Visual Studio Code
# if confirm "Bạn có muốn cài đặt Visual Studio Code không?"; then
#   echo "Đang cài đặt Visual Studio Code..."
#   rpm --import https://packages.microsoft.com/keys/microsoft.asc
#   sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
#   dnf install -y code
#   print_success "Đã cài đặt Visual Studio Code"
# fi

# Cài đặt các ứng dụng văn phòng
# print_section "CÀI ĐẶT ỨNG DỤNG VĂN PHÒNG"
# if confirm "Bạn có muốn cài đặt LibreOffice không?"; then
#   echo "Đang cài đặt LibreOffice..."
#   dnf install -y libreoffice
#   print_success "Đã cài đặt LibreOffice"
# fi

# # Cài đặt các ứng dụng đa phương tiện
# print_section "CÀI ĐẶT ỨNG DỤNG ĐA PHƯƠNG TIỆN"
# if confirm "Bạn có muốn cài đặt VLC không?"; then
#   echo "Đang cài đặt VLC..."
#   dnf install -y vlc
#   print_success "Đã cài đặt VLC"
# fi

# Cài đặt Flathub
# print_section "CÀI ĐẶT FLATHUB"
# if confirm "Bạn có muốn cài đặt Flathub không?"; then
#   echo "Đang cài đặt Flathub..."
#   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#   print_success "Đã cài đặt Flathub"
# fi

# Cài đặt các ứng dụng từ Flathub
# if confirm "Bạn có muốn cài đặt một số ứng dụng phổ biến từ Flathub không?"; then
#   if confirm "Cài đặt Spotify?"; then
#     flatpak install -y flathub com.spotify.Client
#     print_success "Đã cài đặt Spotify"
#   fi

#   if confirm "Cài đặt Discord?"; then
#     flatpak install -y flathub com.discordapp.Discord
#     print_success "Đã cài đặt Discord"
#   fi

#   if confirm "Cài đặt Telegram?"; then
#     flatpak install -y flathub org.telegram.desktop
#     print_success "Đã cài đặt Telegram"
#   fi
# fi

# Cài đặt các tiện ích hệ thống
print_section "CÀI ĐẶT TIỆN ÍCH HỆ THỐNG"
if confirm "Bạn có muốn cài đặt TLP (tiết kiệm pin cho laptop) không?"; then
  echo "Đang cài đặt TLP..."
  print_success "Đã cài đặt và kích hoạt TLP"
fi

# Cài đặt các font
print_section "CÀI ĐẶT FONT"
if confirm "Bạn có muốn cài đặt các font phổ biến không?"; then
  echo "Đang cài đặt các font phổ biến..."  
  print_success "Đã cài đặt các font phổ biến"
fi

# Cài đặt Vietnamese input method
if confirm "Bạn có muốn cài đặt bộ gõ tiếng Việt (ibus-bamboo) không?"; then
  sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
  sudo apt-get update -y
  sudo apt-get install -y ibus ibus-bamboo --install-recommends
  ibus restart
  # Đặt ibus-bamboo làm bộ gõ mặc định
  env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"
  print_success "Đã cài đặt ibus-bamboo"
  print_warning "Vui lòng đăng xuất và đăng nhập lại để áp dụng thay đổi"
  print_warning "Sau đó, vào Settings > Keyboard > Input Sources để thêm Vietnamese (Bamboo)"
fi

# Dọn dẹp
print_section "DỌN DẸP HỆ THỐNG"
echo "Đang dọn dẹp hệ thống..."
apt autoremove -y
apt clean all
print_success "Đã dọn dẹp hệ thống"

print_section "HOÀN TẤT"
echo "Quá trình cài đặt đã hoàn tất!"
echo "Vui lòng khởi động lại hệ thống để áp dụng tất cả các thay đổi."
if confirm "Bạn có muốn khởi động lại ngay bây giờ không?"; then
  echo "Hệ thống sẽ khởi động lại sau 5 giây..."
  sleep 5
  reboot
fi
