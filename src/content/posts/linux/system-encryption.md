---
title: "System encryption"
date: 2020-05-16
draft: true
---

create LUKS container
Only LUKS type 1 is supported for GRUB at this moment.

create container
```
cryptosetup luksFormat --type luks1 /dev/sda2
```

and open it
```
cryptosetup open /dev/sda2 cryptroot
```

crypt root is the name of the opened luks container to be find in `/dev/mapper`

you can craete your file system inside.
```
mkfs.[choose your poison] /dev/mapper/cryptroot
```


### to consider, test and describe
1. what about btrfs volumes on several different devices? should lvm be used? lvm (dev1, dev2) -> luks -> btrfs ?
