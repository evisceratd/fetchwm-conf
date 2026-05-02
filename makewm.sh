#!/bin/sh
#Fetching required files for installation

#Patches 
wget "https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff"
#Sources and configuration files 
git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st 
git clone git://git.suckless.org/slstatus
git https://github.com/evisceratd/fetchwm-conf.git
#Necesssary packages
apk add git gcc make g++ libx11-dev libxinerama-dev libxft-dev ncurses linux-headers patch font-noto tlp alsa-utils brightnessctl dmenu dbus dbus-x11 picom elogind firefox pcmanfm fastfetch
#Installing xorg-server
setup-xorg-base 
#xinit file
echo -e "slstatus &\npicom --backend glx --vsync &\n exec dbus-run-session dwm" > ~/.xinitrc
#Moving files to appropriate dir
mv fetchwm-conf/"config(dwm).h" ~/dwm/config.h
mv fetchwm-conf/"config(st).h" ~/st/config.h
mv fetchwm-conf/"config(sl).h" ~/slstatus/config.h
#Patching dwm
cd ~/dwm ; patch -i dwm-attachaside-6.6.diff ; cd 
#Compile the source
cd ~/dwm/ ; make clean install ; cd ~/st/ ; make clean install ; cd ~/slstatus ; make clean install; cd 
#Starting the WM
startx 
