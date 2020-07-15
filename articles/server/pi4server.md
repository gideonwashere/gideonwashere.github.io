# Ubuntu Server 20.04 on Rapberry Pi 4

I want to set up nextcloud with an external hard drive on my raspberry pi. Ubuntu server seems the best candidate for the job. Download the image [here](https://ubuntu.com/download/raspberry-pi).

You can install this image to an SD card using `dd`. Check which partiotion the card coresponds to using `lsblk`. In my case its `/dev/sda`. Then run

```
dd bs=4M if=ubuntu-20.04.img of=/dev/sda conv=fsync status='progress'
```

Once the image is installed you should be able to ssh into the pi with user and password `ubuntu`.

Ensure system is up to date with `sudo apt update && sudo apt upgrade`. It's also a good idea to reboot if there was a kernel update.

## Booting raspberry pi from ssd

By default the pi uses an SD card as the os device. SD cards are not very reliable and are limited to ~ 50Mbps of bandwidth so it's generally advisable to boot from an external hard drive.

[See instruction here](https://www.tomshardware.com/how-to/boot-raspberry-pi-4-usb)

## Making a new user

I like to make a personal user, delete the default and change the hostname. Here are the steps:

Change the hostname

`$ sudo hostnamectl set-hostname $NAME`

Add new user and add to same groups as user `ubuntu`. Check groups with the `groups` command.

```bash
$ sudo adduser $USER

$ sudo usermod -aG sudo,and,all,other,groups $USER
```

Log out and log back in as $USER then

```
$ deluser ubuntu && delgroup ubuntu
```

## Mounting external drive on startup

Note that nextcloud snap will only have access to `/media` or `/mnt` so make sure you use one of these as your mount point. I'm going to use `/media/storage`.

First create the mountpoint `sudo mkdir -vp /media/storage`

Add a `data` group so non root users can access the storage `sudo groupadd data` and add users to group `sudo usermod -aG data $USER`. Change group for folder `sudo chown -R :data /media/storage`

Now check which drive you want with lsblk. In my case we are looking for the partition `/dev/sda1`, we want to mount by UUID to avoid any mount mistakes. Grab the UUID with `sudo blkid -s UUID -o value /dev/sda1`

Add the entry to `/etc/fstab`. As root

```
echo "UUID=$(blkid -s UUID -o value /dev/sda1) /media/storage auto nosuid,nodev,nofail,noatime 0 2 >> /etc/fstab
```

## Setting up Nextcloud

Since we are using ubuntu, the easiest way to get nextcloud up and running is through the snap package. Just run `snap install nextcloud
