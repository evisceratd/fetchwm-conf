#!/bin/sh
#Remounting write-space with larger size
cd 
mount -o remount,size=3G /
#Patches 
wget "https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff"
#Sources and configuration files 
git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st 
git clone git://git.suckless.org/slstatus
git clone https://github.com/evisceratd/fetchwm-conf.git
#Necesssary packages
apk add git gcc make g++ libx11-dev libxinerama-dev libxft-dev ncurses linux-headers patch font-noto tlp alsa-utils brightnessctl dmenu dbus dbus-x11 picom elogind firefox pcmanfm fastfetch
#Installing xorg-server
setup-xorg-base 
#xinit file
echo -e "slstatus &\npicom --backend glx --vsync &\n exec dbus-run-session dwm" > ~/.xinitrc
#Moving files to appropriate dir
mv fetchwm-conf/config/"config(dwm).h" ~/dwm/config.h
mv fetchwm-conf/config/"config(st).h" ~/st/config.h
mv fetchwm-conf/config/"config(sl).h" ~/slstatus/config.h
#Patching dwm
cd ~/dwm ; patch -i dwm-attachaside-6.6.diff ; cd 
#Compile the source
cd ~/dwm/ ; make clean install ; cd ~/st/ ; make clean install ; cd ~/slstatus ; make clean install; cd 
#Touch to click touchpad
mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "libinput touchpad catchall"\n    MatchIsTouchpad "on"\n    Driver "libinput"\n    Option "Tapping" "on"\nEndSection' | tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null
#Starting services
rc-service dbus start ; rc-service elogind start ; rc-service add dbus ; rc-service add elogind 
#Uninstalling dev packages
apk del gcc make g++ libx11-dev libxinerama-dev libxft-dev ncurses linux-headers patch 
#Removing source files
cd ; rm -rf ./dwm ./st ./slstatus ./dwm-attachaside-6.6.diff ./fetchwm-conf 
#Starting the WM
startx 
