---
title: "GRUB"
date: 2020-05-16
draft: false
---

### UEFI firmware menu entry

**`/etc/grub.d/40_custom`**
```
if [ ${grub_platform} == "efi" ]; then
	menuentry "Firmware setup" {
		fwsetup
	}
fi
```

### encrypted system
configure [system encryption](../system-encryption) and add following options to `/etc/default/grub`
```
GRUB_ENABLE_CRYPTODISK=y
GRUB_CMDLINE_LINUX="cryptdevice=UUID=device-uud:cryptroot root=/dev/mapper/cryptroot cryptkey=rootfs:/root/cryptroot.keyfile"

```
the easy way is to use `cryptdevice=/dev/sda2` but UUID would be preffered

Remember to reinstall grub afer enabling encryption

### grub install
Install grub to `/efi` partition
```
$ grub-install --boot-directory=/efi --bootloader-id=grub --efi-directory=/efi --target=x86_64-efi
```
And generate grub config. Remember it is installed in `/efi`.
```
$ grub-mkconfig -o /efi/grub/grub.cfg
```



