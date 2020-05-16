---
title: "Arch install"
date: 2020-05-16
draft: false
---

# network and system time
network should be already setup and running

manuall configuration is needed if wifi is used

to check if interface is up and running
```
# ip link 
```

to get auto address
```
# dhcpcd
```
to validate
```
# ping archlinux.org
```

system clock
```
# timedatectl set-ntp true
```


# partitioning (using efi, luks and btrfs)
list drives and partitions

```
# blkid
# fdisk -l
```

### create new gpt partition table
1. create efi partition, about 100 MB, type 1
2. create linux partion

### format efi partition
format efi partition
```
# mkfs.vfat /dev/sda1
```

### create and open LUKS container
[System encryption](../system-encryption)

```
# cryptsetup open /dev/sda2 cryptroot
```

### create root filesystem
```
# mkfs.btrfs /dev/mapper/cryptroot
```

# mount and create subvolumes
create subvolumes
```
# mkdir /mnt/{btrfs_root,arch}
# mount /dev/mapper/cryptroot /mnt/btrfs_root
# btrfs subvolume create /mnt/btrfs_root/@
# btrfs subvolume create /mnt/btrfs_root/@home
# btrfs subvolume create /mnt/btrfs_root/@snapshots
# mkdir /mnt/btrfs_root/@/var
# btrfs subvolume create /mnt/btrfs_root/@/var/log
# btrfs subvolume create /mnt/btrfs_root/@/var/tmp
# mkdir -p /mnt/btrfs_root/@/var/cache/pacman
# btrfs subvolume create /mnt/btrfs_root/@/var/cache/pacman/pkg
```
and mount all together
```
# mount /dev/mapper/cryptroot /mnt/arch -o subvol=@
# mkdir /mnt/arch/{efi,home}
# mount /dev/mapper/cryptroot /mnt/arch/home -o subvol=@home
# mount /dev/sda1 /mnt/arch/efi
```
# install
## core arch and utilities
```
# pacstrap /mnt/arch base linux linux-firmware efibootmgr grub vim \
sudo dosfstools btrfs-progs man-db man-pages texinfo intel-ucode \
bash-completion
```
create fstab
```
# genfstab /mnt/arch >> /mnt/arch/etc/fstab
```
change root to new arch install

```
# arch-chroot /mnt/arch
```
## set timezone and system clock
```
# ln -sf /usr/share/zoneinfo/Poland /etc/localtime
# hwclock --systohc
```

## set locales
uncomment en_US.UTF-8 and pl_PL.UTF-8 in `/etc/locale.gen`
generate locales
```
# locale-gen
```
set `/etc/locale.conf`
```
LANG=en_US.UTF-8
LC_NUMERIC=pl_PL.UTF-8
LC_TIME=pl_PL.UTF-8
LC_MONETARY=pl_PL.UTF-8
LC_PAPER=pl_PL.UTF-8
LC_MEASUREMENT=pl_PL.UTF-8
```

## set keyboard layout and console font

TODO

## network configuration
set hostname
```
# echo archie > /etc/hostname
```
`/etc/hosts`
```
127.0.0.1 localhost
::1 localhost
127.0.0.1 archie.localdomain archie
```

set dhcp using systemd
`/etc/systemd/netwok/20-wired.network`
```
[Match]
#Name=enp0s3
Name=en*

[Network]
DHCP=ipv4
DNS=8.8.8.8
DNS=8.8.4.4
```
enable network on start
```
# systemctl enable systemd-networkd
# systemctl enable systemd-resolved
```

## set root password

```
# passwd
```

## configure grub
Follow [grub](../grub) for detalis.

## reboot
if all is fine, especially grub configuration, it shour reboot now.
leave chroot environ with `CTRL-D`, unmount and close luks container
```
# umount -R /mnt/arch
# umount -R /mnt/btrfs_root
# cryptsetup close /dev/mapper/cryptroot
# shutdown -r now

```
----
# the install


## user management
modify /etc/default/useradd
fix HOME variable if using 'layered' home folder

$ useradd -m -G wheel piotr
$ passwd piotr

## modify sudoers
openssh
$ pacman -S openssh
$ sudo systemctl enable sshd

## virtualbox guest (if running as a guest)
sudo pacman -S virtualbox-guest-utils xf86-video-vmware

```
# sudo systemctl enable vboxservice
```

modify /etc/fstab to mount /xtra and windows. check if it mounts automatically

# GUI
```
# pacman -S nvidia nvidia-settings
```

## gnome
$ pacman -S gnome gnome-tweaks chrome-gnome-shell
(co wybrac)
eog 
evince
gdm
gedit 
gnome-calculator
gnome-keyring (?)
gnome-session
gnome-shell
gnome-shell-extentions
gnome-terminal
mutter
nautilus

$ systemctl enable gdm

gnome settings
 mouse acceleration
Use gnow-tweaks and set acceleration to flat

change theme to adwaita dark

https://extensions.gnome.org/
gnome extentions
arch linux updated indicator
dash to dock (a moze plank? pacman -S plank)
shelltile (!)
AppKeys
auto move windows

plank


keepass (gnome-passwordsafe)
$ pacman -S gnome-passwordsafe

jak synchronizowac plik z haslami z google drive?
chromium
privacy badger
adblock 

widevine to play protected content like Netlfix
git clone https://aur.archlinux.org/chromium-widevine.git
makepkg -cCsi




flatpak
$ pacman -S flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

spotify
via aur package
or with flatpak
teamspeak
pacman -S teamspeak3
steam
enambel multilib
sudo pacman -S lib32-nvidia-utils
python
pycharm

terminator?


pacman -S nvidia nvidia-settings lib32-nvidia-utils 

gnome
pacman -S gnome gnome-tweaks 
baobab
eog
evince
gdm
gedit
gnome-calculator
gnome-keyring
gnome-session
gnome-shell
gnome-shell-extentions
mutter
nautilus
file-roller
control-center
password-safe (warning use with python-pykeepass 3.0.3-4-any)
screenshot
settings-daemon
system-monitor
gvfs
gvfs-afc
gvfs-google
gvfs-mtp
totem


### chromium
chromium chrome-gnome-shell
aur: chromium-widevine

### backup and sys utils
aur: timeshift 
aur: backintime
aur: stacer

### graphic and video
darktable
eog
totem (video player, installl gst-libav to play mp4)

### terminals
terminator
cool-retro-term (?)

### music
aur: spotify

### games
steam
teamspeak3

### development
pycharm-community-edition
(sql: postgresql, dbeaver)

# What do I need. And why.
Core
	netutils
	efibootmgr
	grub
	vim, nano
	sudo, visudo
	nvidia drivers (nouveau tears a lot, not usable)
	btrfs-progs, snapper, snap-pac
	fat, exfat and ntfs
	

Internet
	chrome with addons adblock and privacy badger
why: mail, news, youtube, netflix, hbogo, guitar course
https://chrome.google.com/webstore/detail/adblock-%E2%80%94-best-ad-blocker/gighmmpiobklfepjocnamgkkbiglidom
https://chrome.google.com/webstore/detail/privacy-badger/pkehgijcmpdhfbdbbnkijodmdjhbjlgp
gnome shell extentions: https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep
sudo pacman -S chrome-gnome-shell



Music
	spotify
why: because I like to listen music
musescore
	for music notation
audacity
	for audio editing
Yousician (through wine)
	why: to check if and how it works 
Graphic
	eog
		why: quick and simple image viewer
	gimp
		why: for graphic manipulation
	darktable
		digital photo darkroom, like adobe lightroom


Games
	Steam
		why: because I like to play sometimes
wine
why: to play windows games and maybe to run some windows programs

Communication
	TeamSpeak
		why: to talk with tomek mostly
	Skype (aur)
to talk with mom and share pic with tomek
TeamViewer (aur)
	to help mom remotely

System
	lts kernel
	backup, timeshift
GUI (gnome for start, see gnome section for details)
	screenshot tool - to take screenshots of course
	image viewer (eog)
	disk usage analyzer (baobab)
	file manager (nautilus)
	terminal (no gterm, use terminator)
	brasero (simple cd recording software)
	calc
	pdf viewer (evince, what about e-pit, is it possible to do it online?)
	text editor (gedit, maybe something more sophisticated with python, sql, json and xml
 support)
	Google drive integration (Google Backup and Sync through wine?)
	password manager (password safe, keepassxc or keepass through wine)
	nvidia utils
	archlinux pacman updates notifier
	iTunes (through wine) (to connect and manage iPhone if ever needed?)
	automount usb removable devices like drives and camera (my eos350, the other cannon, iphone, pocketbook. it should handle devices which act as drives as well as print/ptp)
	calibre - ebook reader
	timeshift - system config backup
	stacer

Printing
	Samsung M2022W drivers by usb and lan/wi-fi

MS Office
	use office.com

others
	kdenlive - video editing soft
	vlc video player
	
Development
	python
		why: for fun and learning
	PyCharm
		why: good python IDE
	DBeaver
		why: good sql editor if I would need one
	postgresql
		why: to help Adrian with sql
	text editor with python and sql support
		why: for simplicity over PyCharm or DBeaver




