#!/bin/bash

sudo pacman -S dash
sudo ln -sfT dash /usr/bin/sh

# Install pacman hook
cat > /etc/pacman.d/hooks/110-dash-symlink.hook << EOF
[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = bash

[Action]
Description = Re-pointing /bin/sh symlink to dash...
When = PostTransaction
Exec = /usr/bin/ln -sfT dash /usr/bin/sh
Depends = dash
EOF
