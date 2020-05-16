---
title: "GRUB"
date: 2020-05-16
draft: true
---

UEFI firmware menu entry

**`/etc/grub.d/40_custom`**
```
if [ ${grub_platform} == "efi" ]; then
	menuentry "Firmware setup" {
		fwsetup
	}
fi
```
