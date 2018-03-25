#!/bin/bash
# Installs pacman packages
yes | sudo pacman -S snapper snapper-gui snap-pac wine winetricks playonlinux redshift smartmontools nodejs-lts-carbon cherrytree krita-plugin-gmic xdotool wmctrl kvantum-qt5 kvantum-theme-adapta kvantum-theme-arc kvantum-manjaro papirus-icon-theme hardinfo colord-kde gnome-color-manager npm adapta-kde kio-gdrive linux414-headers gparted virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat xf86-input-wacom gericom/smplayer gericom/smplayer-skins unionfs-fuse gimp ncdu xbindkeys git hub ovmf xf86-input-mouse pinfo tree iftop iotop atop nmon powerline-fonts powerline pydf ktouch;

# Installs packages from AUR
yes | yaourt -S google-chrome skypeforlinux-stable-bin ttf-mac-fonts visual-studio-code-bin telegram-desktop-bin latte-dock-git gimp-gtk3-git libinput-gestures osx-el-capitan-theme-git gnome-osx-gtk-theme etcher psensor plasma5-applets-redshift-control-git enpass-bin debtap plasma5-applets-playbar2 plasma5-applets-active-window-control-git capitaine-cursors dropbox megasync-git dolphin-megasync-git drive xboxdrv squashfuse-git gimp-apng gimp-elsamuko-plugins gimp-fix-ca gimp-font-rendering-fix gimp-gap gimp-lensfun gimp-plugin-dcamnoise2 slack-desktop shfmt rclone-browser electrum-ltc pipemeter btrbk otf-droid-sans-mono-powerline-git marker && debtap -u;
powerline-config tmux setup;
mkdir -p ~/.config/powerline;
cat <<-'EOF' > ~/.config/powerline/config.json
{
    "ext": {
        "shell": {
            "theme": "default_leftonly"
        }
    }
}
EOF

# Installs pnpm
curl -L https://unpkg.com/@pnpm/self-installer | node;

cat <<EOF

SET GITSTATUS FOR POWERLINE

Go to: https://github.com/jaspernbrouwer/powerline-gitstatus
and setting up gitstatus theme
EOF

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

./powerline-set
