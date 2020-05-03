# Ubuntu Server 20.04 on Rapberry Pi 4

I want an lxc based server on my raspberry pi. Ubuntu server seems the best candidate for the job. Download the image [here](https://ubuntu.com/download/raspberry-pi).

Once the image is installed you should be able to ssh into the pi with user and password `ubuntu`.

## Making a new user

I like to make a user and delete the default and change the hostname. Here are the steps:

Change the hostname

`$ sudo hostnamectl set-hostname $NAME`

Add new user and add to same groups as user `ubuntu`
```bash
$ sudo adduser $USER

$ sudo usermod -aG sudo,and,all,other,groups $USER

$ deluser ubuntu && delgroup ubunut
```
> Be sure user is added to lxd group

Now everything should be ready to start.

## Setting up lxd

`lxd` is a tool for managing `lxc` containers. It is installed by default on ubuntu server 20.04. At first launch run `lxd init` defaults should be fine for now.

Create a container `lxc launch ubuntu:18.04 $NAME` this will create and start a new ubuntu 18.04 container. You can confirm with `lxc list`

Can execute commands in the lxc container with

`lxc exec $NAME -- <commands>`

For example you can get an interactive shell in the container with `lxc exec $NAME -- /bin/bash`

You can move files to and from the container with `file push/pull`

e.g.

`lxc file push <src> $NAME/<dst>`

`lxc file pull $NAME/<dst> <src>`

To stop a container simply

`lxc stop $NAME`

To remove a container

`lxc delete $NAME`

## Getting new lxc images

LXD comes with 3 default remotes providing images:

    1. ubuntu: (for stable Ubuntu images)
    2. ubuntu-daily: (for daily Ubuntu images)
    3. images: ([for a bunch of other distros](https://us.images.linuxcontainers.org/))

To start a container from them, simply do:
```
lxc launch ubuntu:16.04 my-ubuntu
lxc launch ubuntu-daily:18.04 my-ubuntu-dev
lxc launch images:centos/6/amd64 my-centos
```
