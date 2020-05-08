# Getting Started with Ansible

* Create 3 VMs, one will be the ansible master node and the other 2 will be simple web servers.

* install ansible on the master node.

* navigate to /etc/ansible

* `hosts` (a.k.a 'Inventory') contain lists of child nodes to control

* Edit the hosts file

```
[group name] <-- ip addresses of child hosts
ip-for-host-1
ip-for-host-2

[group name:vars] <-- env vars on child hosts

ansible_user=<user on child host>
ansible_password=<password on child host>

```

* disable `host_key_checking` in `ansible.cfg`

## Ping Host Group

`ansible <group> -m ping`

## Run ad-hoc commands

`ansible linux <group> -a "cat /etc/os-release"`

## Playbook

Configurations spcified in yaml file.

Here is a sample playbook to install nano

/etc/ansible/installnano.yml
```
---
    - name: installnano
      hosts: group
      tasks:
        - name: Ensure nano is installed
          yum:
            name: nano
            state: latest
```

run with `ansible-playbook installnano.yml` idempotent

Change `latest` to `absent`
