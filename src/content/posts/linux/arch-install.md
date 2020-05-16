---
title: "Arch install"
date: 2020-05-16
draft: true
---

# network and system time
network should be already setup and running

manuall configuration is needed if wifi is used

to check if interface is up and running
```
$ ip link 
```

to get auto address
```
$ dhcpcd
```
to validate
```
$ ping archlinux.org
```

system clock
```
# timedatectl set-ntp true
```


# partitioning (using efi, luks and btrfs)
list drives and partitions

```
fdisk -l
```

### create new gpt partition table
1. create efi partition, about 100 MB, type 1
2. create linux partion

### format efi partition
format efi partition
```
mkfs.vfat /dev/sda1
```

### create and open LUKS container
[System encryption](../system-encryption)

```
cryptsetup open /dev/sda2 cryptroot
```

### create root filesystem
```
mkfs.btrfs /dev/mapper/cryptroot
```

# mount and create subvolumes
```
mkdir /mnt/{btrfs_root,arch}
mount /dev/mapper/cryptroot /mnt/btrfs_root
----
# the install
## the net

## partitioning
mount
$ swapon -L swap
$ mount -L arch_root /mnt
$ mkdir -p /mnt/{efi,home/arch}
$ mount /dev/sda2 /mnt/efi
$ mount /dev/sdc2 /mnt/home/arch

pacman install core
$ pacstrap /mnt base linux linux-firmware

to install the very core

$ genfstab -L /mnt >> /mnt/etc/fstab

$ arch-chroot /mnt

install basic tools

$ pacman -S efibootmgr grub os-prober vim sudo dosfstools exfat-utils ntfs-3g man-db man-pages texinfo intel-ucode pacman-contrib bash-completion
timezone

$ ln -sf /usr/share/zoneinfo/Poland /etc/localtime
$ hwclock --systohc

localization
$ vim /etc/locale.gen

$ locale-gen
$ echo LANG=en_US.UTF-8 > /etc/locale.conf

keyboard layout to test po polish programmers with polish console font
also set date to iso, numbers, currency and other local formats

network
$ echo archie > /etc/hostname

$ echo 127.0.0.1 localhost > /etc/hosts
$ echo ::1 localhost >> /etc/hosts
$ echo 127.0.0.1 archie.localdomain archie >> /etc/hosts

dhcp using systemctl
/etc/systemd/network/20-wired.network
[Match]
Name=enp0s3

[Network]
DHCP=ipv4

$ systemctl enable systemd-networkd
$ systemctl enable systemd-resolved
root password
passwd

boot loader
$ grub-install --target=x86_64-efi --efi=/boot --bootloader-id=GRUB
$ grub-mkconfig -o /boot/grub/grub.cfg


reboot
user management
modify /etc/default/useradd
fix HOME variable if using 'layered' home folder

$ useradd -m -G wheel piotr
$ passwd piotr

modify sudoers
openssh
$ pacman -S openssh
$ sudo systemctl enable sshd

use latest bitvise ssh version
virtualbox guest (if running as a guest)
sudo pacman -S virtualbox-guest-utils xf86-video-vmware

$ sudo systemctl enable vboxservice

modify /etc/fstab to mount /xtra and windows. check if it mounts automatically

mount windows and xtra drives
GUI
$pacman -S nvidia nvidia-settings
gnome
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
postgresql ?
dbeaver
java (open java)

terminator?

procedure
prepare for install
format drive with btrfs and create @ subvolume for timeshift

blkid to list devices

fdisk /dev/sdc to manage partitions on 2nd ssd drive, which is for linux in my case

/dev/sdc1 is for home, 176GB
/dev/sdc2 is for arch-root, main arch installation
/dev/sdc3 is for arch-testing, to play around withour taking risk to brake main installation
/dev/sdc4 is for pop os to try and compare if it has anything i would need in arch. or for any other distro

mkfs.btrfs -L <label> -f /dev/sdc<x>

for btrfs create @ subvol
mount /dev/sdc3 /mnt
btrfs subvolume create @ /
do not set @ as default volume. it hides @ and timeshift does not work

umount /mnt
mount -o subvol=@ /dev/sdc3 /mnt
mkdir -p /mnt/{boot/efi,home}
mount /dev/sda2 /mnt/boot/efi
mount /dev/sdc1 /mnt/home (to be verified)

install core with base devel, a co

pacstrap /mnt base base-devel linux linux-firmware

genfstab -L /mnt >> /mnt/etc/fstab

change root to dev because timeshift does not support labels :/

arch-chroot /mnt

install basic tools

pacman -S efibootmgr, os-prober vim sudo dosfstools exfat-utils ntfs-3g man-db man-pages texinfo intel-ucode pacman-contrib

basic config

timezone
ln -sf /usr/share/zoneinfo/Poland /etc/localtime
hwclock --systohc

localization
/etc/locale.gen
en_US.UTF-8
pl_PL.UTF-8

locale-gen

/etc/locale.conf
LANG=pl_PL.UTF-8
LC_MESSAGES=en_US.UTF-8

network

/etc/hosts
127.0.0.1 localhost
::1 localhost
102.0.0.1 sandman-test.localdomain sandman-test

/etc/systemd/network/20-wired.network
[Match]
Name=enp0s3

[Network]
Address=192.168.1.117/24
Gateway=192.168.1.1
DNS=8.8.8.8
DNS=8.8.4.4

systemctl enable systemd-networkd
systemctl enable systemd-resolved

/etc/pacman.conf
enable multilib

/etc/default/useradd
/home/arch

pacman -Syu

root password

passwd

grub-install --target=x86_64-efi --efi=/boot/efi --bootloader-id=GRUB
to chyba nawet nie bedzie potrzebne
grub-mkconfig -o /boot/grub/grub.cfg

gui

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


chromium
chromium chrome-gnome-shell
aur: chromium-widevine

backup and sys utils
aur: timeshift 
aur: backintime
aur: stacer

graphic and video
darktable
eog
totem (video player, installl gst-libav to play mp4)

terminals
terminator
cool-retro-term (?)

music
aur: spotify

games
steam
teamspeak3

development
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




