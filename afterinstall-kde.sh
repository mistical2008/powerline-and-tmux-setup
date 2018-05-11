#!/bin/bash
# Installs pacman packages
yes | sudo pacman -S snapper snapper-gui snap-pac wine winetricks playonlinux redshift smartmontools nodejs-lts-carbon cherrytree krita-plugin-gmic xdotool wmctrl kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-manjaro papirus-icon-theme hardinfo colord-kde gnome-color-manager npm adapta-kde kio-gdrive gparted virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat xf86-input-wacom gericom/smplayer gericom/smplayer-skins unionfs-fuse gimp ncdu xbindkeys git hub ovmf xf86-input-mouse pinfo tree iftop iotop atop nmon powerline-fonts powerline pydf ktouch lib32-gnutls;

# Installs packages from AUR
yes | yaourt -S google-chrome skypeforlinux-stable-bin ttf-mac-fonts visual-studio-code-bin telegram-desktop-bin latte-dock-git gimp-gtk3-git libinput-gestures osx-el-capitan-theme-git gnome-osx-gtk-theme etcher psensor plasma5-applets-redshift-control-git enpass-bin debtap plasma5-applets-playbar2 plasma5-applets-active-window-control-git capitaine-cursors dropbox megasync-git dolphin-megasync-git drive xboxdrv squashfuse-git gimp-apng gimp-elsamuko-plugins gimp-fix-ca gimp-font-rendering-fix gimp-gap gimp-lensfun gimp-plugin-dcamnoise2 slack-desktop shfmt rclone-browser electrum-ltc pipemeter btrbk otf-droid-sans-mono-powerline-git marker xampp system-san-francisco-font-git pcloud-drive pcloudcc tusk android-sdk-platform-tools autokey-py3 && debtap -u;

# Installing megasync
#wget https://mega.nz/linux/MEGAsync/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.xz;
#sudo pacman -U megasync-x86_64.pkg.tar.xz;
#rm -rf megasync-x86_64.pkg.tar.xz;

powerline-config tmux setup;
mkdir -p ~/.config/powerline;

# Installs organizer
sudo pip3 install organize-tool;
# Copy sevices and timers to systemd path
sudo cp services/* /etc/systemd/system/
# Start and enable services
sudo systemctl start organizer.service
sudo systemctl enable organizer.service
sudo systemctl start backup-settings.service
sudo systemctl enable backup-settings.service

# Installs pnpm
curl -L https://unpkg.com/@pnpm/self-installer | node;

cat <<EOF

SET GITSTATUS FOR POWERLINE

Go to: https://github.com/jaspernbrouwer/powerline-gitstatus
and setting up gitstatus theme
EOF

# Setting up tmux
cat <<EOF> ~/.tmux.conf

# Point out to powerline
source /usr/lib/python3.6/site-packages/powerline/bindings/tmux/powerline.conf

# Set colors support
set -g default-terminal "xterm-256color"

# set mouse on
set -g mouse on

# Set hook for continuum plugin
set -g @continuum-restore 'on'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

EOF

# Setting up powerline theme
./powerline-set.sh

# Setting pacman HOOKs
sudo cp pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;

# Install of kcm-wacomtablet
cat <<EOF
================ COPY LINES ABOVE ==================

# Maintainer: Lukas Jirkovsky <l.jirkovsky@gmail.com>
pkgname=kcm-wacomtablet-frameworks-git
pkgver=477.5e6729f
pkgrel=1
epoch=1
pkgdesc="KDE GUI for the Wacom Linux Drivers (KF5 branch)"
arch=('i686' 'x86_64')
url="https://www.linux-apps.com/p/1127862/"
license=('GPL2')
depends=('plasma-framework' 'xf86-input-wacom')
makedepends=('git' 'cmake' 'extra-cmake-modules' 'kdoctools' 'kdelibs4support' 'python')
conflicts=('kcm-wacomtablet')
source=('git://anongit.kde.org/wacomtablet#branch=releng3.0')
md5sums=('SKIP')

pkgver() {
  cd "$srcdir/wacomtablet"
  echo $(git rev-list --count master).$(git rev-parse --short master)
}

build() {
  cd "$srcdir/wacomtablet"

  cmake . \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
  make
}

package() {
  cd "$srcdir/wacomtablet"

  make DESTDIR="$pkgdir" install
  
=============== end of copy lines ===================

EOF

sleep 10

cat <<EOF

REPLACE PCKGBUILD CONTENT WITH COPIED LINES

EOF

sleep 3

yes | yaourt -S kcm-wacomtablet-git


# Copy ~/.bashrc and ~/.bash_aliases
cat<<EOF

COPY BASH FILES? (~/.bashrc and ~/.bash_aliases)
TYPE Y(yes) or N(no)
EOF

read -p "Chosse your answer: " ANSWER
if [[ $ANSWER -eq "Y" ]] || [[ $ANSWER -eq "Yes" ]] || [[ $ANSWER -eq "y" ]] || [[ $ANSWER -eq "yes" ]]; then
	bash/.bashrc >> ~/.bashrc;
	cp bash/bash_aliases ~/;
fi
