---
title: "System encryption"
date: 2020-05-16
draft: false
---
## Prepare system partition
Only LUKS type 1 is supported for GRUB at this moment.

Create container
```
cryptosetup luksFormat --type luks1 /dev/sda2
```
and open it
```
cryptosetup open /dev/sda2 cryptroot
```
`cryptroot` is the name of the opened luks container to be find in `/dev/mapper`

you can craete your file system inside.
```
mkfs.btrfs /dev/mapper/cryptroot
```

## boot loader configuration

### enable encrypt hook
add encrypt hook to `mkinitcpio.conf`
```
HOOKS=(base udev autodetect keyboard keymap consolefont modconf block *encrypt* filesystems fsck)
```
### generate and add keyfile
```
$ dd bs=512 count=4 if=/dev/random of=/root/cryptroot.keyfile iflag=fullblock
$ chmod 000 /root/cryptroot.keyfile
$ cryptsetup luksAddKey /dev/sda2 /root/cryptroot.keyfile
```
after creting and adding key to container, add keyfile to initramfs image and to kernel parameters
`mkinitcpio.conf`
```
FILES=(/root/cryptroot.keyfile)
```
Refresh initramfs image
```
$ mkinitcpio -p linux
```
And secure the embeded key file
```
$ chmod 600 /boot/initramfs-linux*
```
### configure bootloader
Set the following kernel param for grub
`/etc/default/grub`
```
GRUB_CMDLINE_LINUX="... cryptkey=rootfs:/root/cryptroot.keyfile"
```
and regenerate grub config


## to consider, test and describe
1. what about btrfs volumes on several different devices? should lvm be used? lvm (dev1, dev2) -> luks -> btrfs ?
