#!/bin/bash
# Installs pacman packages
yes | sudo pacman -S --needed $(< pkg.pac.txt);

# Installs packages from AUR
yes | yaourt -S --needed $(< pkg.aur.txt) && debtap -u;

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

# Setting up powerline theme
./powerline-set.sh


# Copy ~/.bashrc and ~/.bash_aliases
cat<<EOF

COPY BASH FILES? (~/.bashrc and ~/.bash_aliases)
TYPE Y(yes) or N(no)
EOF

#read -p "Chosse your answer: " ANSWER
#if [[ $ANSWER == Y | $ANSWER == y | $ANSWER == yes| $ANSWER == Yes ]]; then
#	.bashrc >> ~/.bashrc;
#	cp bash_aliases ~/bash_aliales;
#fi
