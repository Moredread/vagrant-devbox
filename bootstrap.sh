#!/bin/sh

pacman -Suy --noconfirm
pacman -R --noconfirm virtualbox-guest-utils-nox
pacman -S --noconfirm --needed less zsh i3 gdm dmenu git tk gnome-keyring python2 python2-pip python-pip xorg-server-utils xorg-apps virtualbox-guest-utils gvim rxvt-unicode firefox chromium

cat <<EOF >/home/vagrant/.autostart.sh
#!/bin/sh

sleep 10
/usr/bin/VBoxClient-all
EOF
chmod 755 /home/vagrant/.autostart.sh
chown vagrant:vagrant /home/vagrant/.autostart.sh

mkdir -p /home/vagrant/.config/autostart
cat <<EOF >/home/vagrant/.config/autostart/xinitrc.desktop
[Desktop Entry]
Name=Autostart
Comment=Automatically start listed applications when gdm starts.
Exec=.autostart.sh
Icon=/usr/share/icons/5.png
Terminal=false
Type=Application
Categories=Configuration
EOF
chmod 755 /home/vagrant/.config/autostart
chown vagrant:vagrant /home/vagrant/.config -R

systemctl enable gdm
systemctl start gdm
systemctl enable vboxservice
systemctl start vboxservice
