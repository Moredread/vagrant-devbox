#!/bin/sh

USERHOME=/home/vagrant

pacman -Suy --noconfirm
pacman -R --noconfirm virtualbox-guest-utils-nox
pacman -S --noconfirm --needed less zsh i3 gdm dmenu git tk gnome-keyring python2 python2-pip python-pip xorg-server-utils xorg-apps virtualbox-guest-utils gvim rxvt-unicode firefox chromium xclip ttf-bitstream-vera mesa-demos vagrant virtualbox qt4 virtualbox-ext-vnc

chsh -s /bin/zsh vagrant
if [ ! -d "${USERHOME}/.oh-my-zsh" ]; then
sudo -u vagrant git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ${USERHOME}/.oh-my-zshs
fi

cat > /etc/modules-load.d/virtualbox-host.conf <<END
vboxdrv
vboxnetadp
vboxnetflt
vboxpci
END

systemctl restart systemd-modules-load.service

if [ ! -d "${USERHOME}/.dotfiles" ]; then
sudo -u vagrant git clone https://github.com/Moredread/dotfiles ${USERHOME}/.dotfiles
else
sudo -u vagrant sh -c "cd ${USERHOME}/.dotfiles; git pull; git submodule update --init"
fi

sudo -u vagrant sh -c "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"

if [ ! -d "${USERHOME}/.vim/bundle/rust.vim" ]; then
sudo -u vagrant git clone https://github.com/rust-lang/rust.vim ${USERHOME}/.vim/bundle/rust.vim
else
sudo -u vagrant sh -c "cd ${USERHOME}/.vim/bundle/rust.vim; git pull; git submodule update --init"
fi

sudo -u vagrant sh -c "cd ${USERHOME}/.dotfiles; make"

systemctl enable gdm
systemctl start gdm
systemctl enable vboxservice
systemctl start vboxservice

sudo -u vagrant sh -c "cd ${USERHOME}; git clone --recursive https://github.com/brson/multirust; cd multirust; git pull; git submodule update --init; ./build.sh && sudo ./install.sh; multirust update stable; multirust update nightly; multirust default nightly"
