#!/bin/sh

set -e

USER_NAME="$(whoami)"
HOME_DIR="$HOME"

echo "[*] Updating repositories..."
apk update

echo "[*] Installing packages..."
apk add \
    git \
    gcc \
    g++ \
    make \
    patch \
    linux-headers \
    libx11-dev \
    libxinerama-dev \
    libxft-dev \
    ncurses \
    xinit \
    dbus \
    dbus-x11 \
    elogind \
    polkit-elogind \
    picom \
    dmenu \
    firefox \
    pcmanfm \
    fastfetch \
    alsa-utils \
    brightnessctl \
    tlp \
    font-noto

echo "[*] Installing Xorg..."
setup-xorg-base

echo "[*] Enabling services..."
rc-update add dbus
rc-update add elogind

rc-service dbus start
rc-service elogind start

echo "[*] Configuring rootless Xorg..."
mkdir -p /etc/X11

cat > /etc/X11/Xwrapper.config <<EOF
allowed_users=anybody
needs_root_rights=no
EOF

echo "[*] Adding user to required groups..."
addgroup "$USER_NAME" video
addgroup "$USER_NAME" input
addgroup "$USER_NAME" audio

echo "[*] Cloning suckless software..."
cd "$HOME_DIR"

git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st
git clone git://git.suckless.org/slstatus
git clone https://github.com/evisceratd/fetchwm-conf.git

echo "[*] Downloading dwm patch..."
wget https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff

echo "[*] Applying configs..."
cp fetchwm-conf/config/"config(dwm).h" dwm/config.h
cp fetchwm-conf/config/"config(st).h" st/config.h
cp fetchwm-conf/config/"config(sl).h" slstatus/config.h

echo "[*] Patching dwm..."
cd "$HOME_DIR/dwm"
patch -p1 < "$HOME_DIR/dwm-attachaside-6.6.diff"

echo "[*] Building dwm..."
make clean install

echo "[*] Building st..."
cd "$HOME_DIR/st"
make clean install

echo "[*] Building slstatus..."
cd "$HOME_DIR/slstatus"
make clean install

echo "[*] Creating .xinitrc..."

cat > "$HOME_DIR/.xinitrc" <<EOF
slstatus &
picom --backend glx --vsync &
exec dbus-launch --exit-with-session dwm
EOF

chmod +x "$HOME_DIR/.xinitrc"

echo "[*] Enabling tap-to-click..."
mkdir -p /etc/X11/xorg.conf.d

cat > /etc/X11/xorg.conf.d/30-touchpad.conf <<EOF
Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
EndSection
EOF

echo "[*] Cleaning temporary files..."
cd "$HOME_DIR"

rm -rf \
    fetchwm-conf \
    dwm-attachaside-6.6.diff

echo
echo "[*] Installation complete."
echo "[*] Reboot recommended."
echo
echo "After reboot:"
echo "    startx"
