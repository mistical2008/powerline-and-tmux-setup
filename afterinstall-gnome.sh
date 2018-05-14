#!/bin/bash
NC='\033[0m';
BROWN='\033[0;33m';

gpg --receive-keys D1483FA6C3C07136;

# Installs pacman packages
yes | sudo pacman -S --needed - < pkg.pac.txt;

# Installs packages from AUR
cat pkg.aur.txt | xargs yaourt -S --needed --noconfirm && debtap -u;

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

printf "${BROWN}SET GITSTATUS FOR POWERLINE${NC}"
cat <<EOF

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
if [[ -d /etc/pacman.d/hooks ]]; then
sudo cp pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;
else
sudo mkdir /etc/pacman.d/hooks/;
sudo cp pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;
fi

# Copy ~/.bashrc and ~/.bash_aliases

printf "${BROWN}COPY BASH FILES? (~/.bashrc and ~/.bash_aliases)${NC}"
echo "TYPE Y(yes) or N(no)"

read -p "Chosse your answer: " ANSWER
if [[ $ANSWER -eq "Y" ]] || [[ $ANSWER -eq "Yes" ]] || [[ $ANSWER -eq "y" ]] || [[ $ANSWER -eq "yes" ]]; then
	cat bash/.bashrc >> ~/.bashrc;
	cp bash/bash_aliases ~/;
fi
