# Home Lab

![Proxmox Logo][logo]

Proxmox Virtual Environment is an open source server virtualization management solution based on QEMU/KVM and LXC. You can manage virtual machines, containers, highly available clusters, storage and networks with an integrated, easy-to-use web interface or via CLI. Proxmox VE code is licensed under the GNU Affero General Public License, version 3.

> We will be using Proxmox v6, which is based on debian buster.

## Installing Proxmox

Install proxmox using the [Installation Guide][2]. Proxmox is configured to load updates from the enterprise repository by default. The enterprise repository requires a subscription to use, but the community repository is available to use for free. To configure proxmox to use the community repo navigate to the web interface `https://<proxmox-ip>:8006`. Go to the proxmox root node in the top left and open up a shell. Run the following to disable the enterprise list and enable

```
cd /etc/apt/sources.list.d
mv pve-enterprise.list pve-enterprise.list.disabled
echo 'deb http://download.proxmox.com/debian/pve buster pve-no-subscription' > pve-community.list
apt update
apt -y dist-upgrade
```

Proxmox will now get updates through the community repo.

## Building an Intranet with pfSense


[1]: https://pve.proxmox.com/wiki/Main_Page "Proxmox Main Page"
[2]: https://pve.proxmox.com/wiki/Prepare_Installation_Media "Proxmox Install Guide"
[3]: https://www.proxmox.com/en/downloads/category/iso-images-pve "Proxmox Download"

[logo]: https://www.proxmox.com/images/proxmox/Proxmox_logo_standard_hex_400px.png "Proxmox Logo"
