#!/usr/bin/env bash
# На установленной системе поставь snapper и фронт к нему:
sudo pacman -S snapper-gui

# Монтируем root и home. Так будут доступны для просмотра @ и @home по пути /mnt/@ и /mnt/@home
# Не забудь сменить VG0-lvol_root VG0-lvol_home на свои имена
sudo mkdir /mnt/{btrfs,btrfs_home} #создаем точки монтирования для @ и @home
sudo mount -t btrfs /dev/mapper/VG0-lvol_root /mnt/btrfs # Проверь пути VG0-lvol_root
sudo mount -t btrfs /dev/mapper/VG0-lvol_home /mnt/btrfs_home # Проверь пути VG0-lvol_home

# Затем создай конфиги для root и home:
sudo snapper -c root create config /
sudo snapper -c home create config /home

# Snapper создает сабволюмы не лучшим образом, исправим это. Удалим те, что есть и создадим свои
btrfs subvolume delete /.snapshots;
btrfs subvolume delete /home/.snapshots;
btrfs subvolume create /mnt/btrfs/@snapshots;
btrfs subvolume create /mnt/btrfs_home/@snapshots;

# Теперь создадим точки монтирования для сабволюмов со снимками
mkdir /home/.snapshots;
mkdir /.snapshots;
chown $(whoami).users /home/.snapshots;
chown $(whoami).users /.snapshots;

# Добавляем демон snapper в автозагрузку
systemctl start snapper-timeline.timer snapper-cleanup.timer;
systemctl enable snapper-timeline.timer snapper-cleanup.timer;

# Теперь монтируем сабволюмы на постоянной основе)
echo " " >> /etc/fstab;
echo "# Btrfs mounts" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_root /mnt/btrfs          btrfs   rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_root /.snapshots         btrfs   subvol=@snapshots,rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_home /mnt/btrfs_home     btrfs   rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
echo "/dev/mapper/VG0-lvol_home /home/.snapshots    btrfs   subvol=@snapshots,rw,noatime,space_cache,autodefrag,discard,compress=lzo  0 0" >> /etc/fstab;
