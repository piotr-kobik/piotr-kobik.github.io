---
title: "Wireless configuration"
date: 2020-05-16
draft: false
---

install wpa_supplicant
```
# pacman -S wpa_supplicant
```

create minima wpa_supplicant configuration file to allow interface to scan and update configuration
`/etc/wpa_supplicant/wpa_supplicant.conf`
```
ctrl_interface=/run/wpa_supplicant
update_config=1
```
check interface name with:
```
# ip link show
```
start wpa_supplicant with:
```
# wpa_supplicant -B -i _inteface_ -c /etc/wpa_supplicant/wpa_cupplicant.conf
```
to update config interactively
```
# wpa_cli
> scan
> scan_results
> add_network
0
> set_network 0 ssid "Your network"
> set_network 0 psk "Network password"
> enable_network 0
> save_config
> quit
```
check updated config
```
# cat /etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

network={
	ssid="your network"
	psk="network password"
}
```
replace psk with wpa_passphrase
```
# wpa_passphrase MYSSID passphrase
```
and update `wpa_supplicant.conf`
```
network={
	ssid="your network"
	#psk="network password"
	psk=59e012901ef8fe8efff9e810232efe1
}
```
copy `wpa_supplicant.conf` as `wpa_supplicant-interface.conf`
enable systemd service for this interface
```
# systemctl enable wpa_supplicant@inteface
```

create systemd wireless config
`/etc/systemd/network/25-wireless.network`
```
[Match]
Name=wl*

[Network]
DHCP=ipv4
DNS=8.8.8.8
DNS=8.8.4.4

[DHCP]
#set wired to 10
RouteMetric=20
```

