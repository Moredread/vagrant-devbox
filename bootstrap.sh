#!/bin/sh

USERHOME=/home/vagrant

pacman -Suy --noconfirm
pacman -R --noconfirm virtualbox-guest-utils-nox
pacman -S --noconfirm --needed less zsh i3 gdm dmenu git tk gnome-keyring python2 python2-pip python-pip xorg-server-utils xorg-apps virtualbox-guest-utils gvim rxvt-unicode firefox chromium xclip ttf-bitstream-vera mesa-demos qt4 xsel
pacman -S --noconfirm --needed wget docker lxc btrfs-progs lua-filesystem lua-alt-getopt ghc cabal-install happy haddock alex ccache cifs-utils atop sysstat pv python-nose python-scipy python-tox jdk8-openjdk
pacman -S --noconfirm --needed texlive-most texlive-lang evince pandoc cmake swig python-pexpect python2-pexpect gdb go

chsh -s /bin/zsh vagrant
if [ ! -d "${USERHOME}/.oh-my-zsh" ]; then
sudo -u vagrant git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ${USERHOME}/.oh-my-zshs
fi

systemctl restart systemd-modules-load.service

if [ ! -d "${USERHOME}/.dotfiles" ]; then
sudo -u vagrant git clone https://github.com/Moredread/dotfiles ${USERHOME}/.dotfiles
else
sudo -u vagrant sh -c "cd ${USERHOME}/.dotfiles; git pull; git submodule update --init"
fi

sudo -u vagrant sh -c "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"

if [ ! -d "${USERHOME}/.vim/bundle/rust.vim" ]; then
sudo -u vagrant git clone https://github.com/rust-lang/rust.vim ${USERHOME}/.vim/bundle/rust.vim --recursive
else
sudo -u vagrant sh -c "cd ${USERHOME}/.vim/bundle/rust.vim; git pull; git submodule update --init"
fi

if [ ! -d "${USERHOME}/.vim/bundle/gundo" ]; then
sudo -u vagrant git clone https://github.com/sjl/gundo.vim.git ${USERHOME}/.vim/bundle/gundo --recursive
else
sudo -u vagrant sh -c "cd ${USERHOME}/.vim/bundle/gundo; git pull; git submodule update --init"
fi

if [ ! -d "${USERHOME}/.vim/undodir" ]; then
sudo -u vagrant ${USERHOME}/.vim/undodir
fi

if [ ! -d "${USERHOME}/.vim/bundle/racer.vim" ]; then
sudo -u vagrant git clone https://github.com/racer-rust/vim-racer ${USERHOME}/.vim/bundle/racer.vim --recursive
else
sudo -u vagrant sh -c "cd ${USERHOME}/.vim/bundle/racer.vim; git pull; git submodule update --init"
fi

if [ ! -d "${USERHOME}/rust" ]; then
sudo -u vagrant git clone https://github.com/rust-lang/rust ${USERHOME}/rust --depth 10
else
sudo -u vagrant sh -c "cd ${USERHOME}/rust; git pull"
fi

sudo -u vagrant sh -c "cd ${USERHOME}/.dotfiles; make"

systemctl enable gdm
systemctl start gdm
systemctl enable vboxservice
systemctl start vboxservice
systemctl enable docker
systemctl start docker

sudo -u vagrant sh -c "cd ${USERHOME}; git clone --recursive https://github.com/brson/multirust; cd multirust; git pull; git submodule update --init; ./build.sh && sudo ./install.sh; multirust update stable; multirust update nightly; multirust default nightly"
