# Partitions for Arch install with BTRFS

Partitions we need:
* **EFI** formatted as FAT32 for boot (550MB)
* **SWAP** this can be replaced by a swapfile, but btrfs is still a bit iffy on swap files so better to make its own partition. (If Hibernate =RAM, no Hibernate ~sqrt(RAM))
* **System** this will be the btrfs system to hold *root* and *home*

The System partition will consist of the following subvolumes, this is the layout recommended by snapper (OpenSUSE):
- btrfs Top Level
-- @ (/)
-- @home (/home)
-- @snapshots (/.snapshots)
-- @/var/log (/var/log)

## Partition and format the drive

Make three partions like normal. We want a GPT volume here.

Format the partitions:
* EFI: `mkfs.fat -F32 -n EFI /dev/<partition>`
* SWAP: `mkswap -L swap /dev/<partition> && swapon`
* System: `mkfs.btrfs --label system /dev/<partition>`

## Basic btrfs commands

--

## Make btrfs subvolumes

Now we need to temporarily mount the btrfs volume to make subvolumes. It useful to set upsome mount variables first

```
# o=defaults,x-mount.mkdir
# o_btrfs=$o,compress=lzo,ssd,noatime
```

`o` are the default for any filesystem. Note `x-mount.mkdir` will automatically create directories for mountpoints which is nice. `o_btrfs` are btrfs specific options.

Now we can mount the system partition

`mount -t btrfs LABEL=system /mnt`

Now create the subvolumes
* `btrfs subvolume create /mnt/root`
* `btrfs subvolume create /mnt/home`
* `btrfs subvolume create /mnt/snapshots`

Unmount `umount -R /mnt`

## Mount everything

Now we can remount the subvolumes. The root volume will remain unmounted unless we need to rollback.

`mount -t btrfs -o subvol=root,$o_btrfs LABEL=system /mnt`

* `-t btrfs` specifies the filesystem type to mount, mount is usually smart enough to figure this out, but it's good to be specific.
* `-o <options>` specify the root subvolume and the options we defined earlier. Coupled with the `LABEL=system` argument, this tells mount to mount the 'root' subvolume in the partition labeled 'system'.

Now mount home and subvol:
* `mount -t btrfs -o subvol=home,$o_btrfs LABEL=system /mnt/home`
* `mount -t btrfs -o subvol=snapshots,$o_btrfs LABEL=system /mnt/.snapshots`

Now just mount the boot partion
```
mkdir /mnt/boot
mount LABEL=EFI /mnt/boot
```
and continue with the normal arch install
