#!/usr/bin/env bash
NC='\033[0m';
BROWN='\033[0;33m';

gpg --receive-keys D1483FA6C3C07136;

# Create dirs for mountpoints
sudo mkdir /mnt/{btrfs,btrfs_home,Data,Downloads} /media;
chown $(whoami).users  /mnt/{Data,Downloads} /media;

# Mount btrfs
sudo mount -t btrfs /dev/mapper/VG0-lvol_root /mnt/btrfs;
sudo mount -t btrfs /dev/mapper/VG0-lvol_home /mnt/btrfs_home;

# Install and configure snapper
sudo pacman -S snapper;
snapper -c root create-config /;
snapper -c home create-config /home;

btrfs subvolume delete /.snapshots;
btrfs subvolume delete /home/.snapshots;
btrfs subvolume create /mnt/btrfs/@snapshots;
btrfs subvolume create /mnt/btrfs_home/@snapshots;

mkdir /home/.snapshots;
mkdir /.snapshots;
chown $(whoami).users /home/.snapshots;
chown $(whoami).users /.snapshots;

systemctl start snapper-timeline.timer snapper-cleanup.timer;
systemctl enable snapper-timeline.timer snapper-cleanup.timer;

#===================================

# Mount btrfs dirs
echo " " >> /etc/fstab;
echo "# Btrfs mounts" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_root /mnt/btrfs          btrfs   rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_root /.snapshots         btrfs   subvol=@snapshots,rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_home /mnt/btrfs_home     btrfs   rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_home /home/.snapshots    btrfs   subvol=@snapshots,rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;

# Mount forlders
echo " " >> /etc/fstab;
echo "# Call for Data" >> /etc/fstab;
echo "/dev/sdb4 /mnt/Data          $(lsblk -no FSTYPE /dev/sdb4)    rw,auto,nosuid,dev,nofail                     0 0" >> /etc/fstab;
echo "/dev/sdb4 /media             $(lsblk -no FSTYPE /dev/sdb4)    rw,auto,nosuid,dev,nofail                     0 0" >> /etc/fstab;
echo "/dev/sdb3 /mnt/Downloads     $(lsblk -no FSTYPE /dev/sdb3)    rw,auto,nosuid,dev,nofail,noatime,logbufs=8     0 0" >> /etc/fstab;
echo " " >> /etc/fstab;
#cat def-mounts >> /etc/fstab

#==================================

# Mount all from fstab
mount -a;

# Disable CoW for VM folder
mkdir /home/evgeniy/VM;
chown evgeniy.users /home/evgeniy/VM;
chattr +C /home/evgeniy/VM;

# Installs pacman packages
yes | sudo pacman -S --needed - < pkg.pac.txt;

# Installs packages from AUR
cat pkg.aur.txt | xargs yaourt -S --needed --noconfirm && debtap -u;

# Installing megasync
#wget https://mega.nz/linux/MEGAsync/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.xz;
#sudo pacman -U megasync-x86_64.pkg.tar.xz;
#rm -rf megasync-x86_64.pkg.tar.xz;


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
cat <<EOF> /home/evgeniy/.tmux.conf

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

# Setting pacman HOOKs
if [[ -d "/etc/pacman.d/hooks" ]]; then
sudo cp ./pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;
else
sudo mkdir /etc/pacman.d/hooks/;
sudo cp ./pac-hooks/installed-pkgs.hook /etc/pacman.d/hooks/;
fi

# Copy ~/.bashrc and ~/.bash_aliases

printf "${BROWN}COPY BASH FILES? (~/.bashrc and ~/.bash_aliases)${NC}"
echo "TYPE Y(yes) or N(no)"

read -p "Chosse your answer: " ANSWER
if [[ $ANSWER -eq "Y" ]] || [[ $ANSWER -eq "Yes" ]] || [[ $ANSWER -eq "y" ]] || [[ $ANSWER -eq "yes" ]]; then
	cat ./bash/.bashrc >> /home/evgeniy/.bashrc;
	cp ./bash/.bash_aliases /home/evgeniy/;
fi
