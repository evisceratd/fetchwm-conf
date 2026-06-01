#!/bin/sh
#Remounting write-space with larger size
cd 
mount -o remount,size=3G /run/live/overlay
#Patches 
wget "https://dwm.suckless.org/patches/attachaside/dwm-attachaside-6.6.diff"
#Sources and configuration files 
git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st 
git clone git://git.suckless.org/slstatus
#Necesssary packages
sudo apt install -y build-essential libx11-dev libxinerama-dev libxft-dev ncurses linux-headers patch font-noto tlp alsa-utils brightnessctl dmenu dbus dbus-x11 picom elogind pcmanfm fastfetch
#Installing xorg-server
sudo apt install -y xorg xinit
#creating user xinit file
echo -e "slstatus &\npicom --backend glx --vsync &\n exec dbus-run-session dwm" > ~/.xinitrc
#Moving files to appropriate dir
mv fetchwm-conf/config/"config(dwm).h" ~/dwm/config.h
mv fetchwm-conf/config/"config(st).h" ~/st/config.h
mv fetchwm-conf/config/"config(sl).h" ~/slstatus/config.h
#Patching dwm
cd ~/dwm ; patch -i ~/dwm-attachaside-6.6.diff ; cd 
#Compile the source
cd ~/dwm/ ; make clean install ; cd ~/st/ ; make clean install ; cd ~/slstatus ; make clean install; cd 
#Touch to click touchpad
mkdir -p /etc/X11/xorg.conf.d && echo -e 'Section "InputClass"\n    Identifier "libinput touchpad catchall"\n    MatchIsTouchpad "on"\n    Driver "libinput"\n    Option "Tapping" "on"\nEndSection' | tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null
#Starting services
sudo systemctl enable dbus ; sudo systemctl enable elogind ; sudo systemctl start dbus ; sudo systemctl start elogind 
#Uninstalling dev packages
sudo apt remove -y build-essential libx11-dev libxinerama-dev libxft-dev ncurses linux-headers patch; sudo apt autoremove -y
#Leaving Tips
cd ; mv ./fetchwm-conf/tips.txt ~/tips.txt
#Removing source files
cd ; rm -rf ./dwm ./st ./slstatus ./dwm-attachaside-6.6.diff ./fetchwm-conf 
#Starting the WM
#startx
