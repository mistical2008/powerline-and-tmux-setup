#!/bin/bash
# Installs pacman packages
yes | sudo pacman -S snapper snapper-gui snap-pac wine winetricks playonlinux redshift smartmontools nodejs-lts-carbon cherrytree krita-plugin-gmic xdotool wmctrl papirus-icon-theme hardinfo gnome-color-manager npm gparted virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat xf86-input-wacom gericom/smplayer gericom/smplayer-skins unionfs-fuse gimp ncdu xbindkeys git hub ovmf xf86-input-mouse pinfo tree iftop iotop atop nmon powerline-fonts powerline pydf lib32-gnutls;

# Installs packages from AUR
yes | yaourt -S google-chrome skypeforlinux-stable-bin ttf-mac-fonts visual-studio-code-bin telegram-desktop-bin gimp-gtk3-git libinput-gestures osx-el-capitan-theme-git gnome-osx-gtk-theme etcher psensor plasma5-applets-redshift-control-git enpass-bin debtap plasma5-applets-playbar2 plasma5-applets-active-window-control-git capitaine-cursors dropbox megasync-git drive xboxdrv squashfuse-git gimp-apng gimp-elsamuko-plugins gimp-fix-ca gimp-font-rendering-fix gimp-gap gimp-lensfun gimp-plugin-dcamnoise2 slack-desktop shfmt rclone-browser electrum-ltc pipemeter btrbk otf-droid-sans-mono-powerline-git marker xampp system-san-francisco-font-git pcloud-drive pcloudcc tusk android-sdk-platform-tools autokey-py3 && debtap -u;

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
# Start and enable organizer service
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

# Adding custom repositories
cat <<EOF>> /etc/pacman.conf
========================================================
# Custom repositories
# Manjaro-strit
[manjaro-strit]
SigLevel = Optional
Server = https://www.strits.dk/files/manjaro-strit/manjaro-strit-repo/$arch

# Gericom
[gericom]
SigLevel = Never
Server = http://download.tuxfamily.org/gericom/manjaro

# Kibojoe
#[kibojoe]
#SigLevel = Never
#Server = http://repo.kibojoe.org/

EOF

# Setting pacman HOOKs
sudo cp pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;

# Setting up powerline theme
./powerline-set.sh


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
