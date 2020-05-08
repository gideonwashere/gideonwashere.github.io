# Ansible

Ansible is an open-source software provisioning, configuration management, and application-deployment tool. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows. It includes its own declarative language to describe system configuration. Ansible is push based and agentless. Configurations are pushed - generally over ssh, so no agent software needs to be installed on the target node. Generally speaking you will have a main *orchestration* node which has ansible installed and stores host information for all child nodes.
![Ansible Logo][logo]

## Articles

* [Simple Ansible Tutorial](./ansible-getting-started.md)

## References

* [Ansible Wikipedia][1]

[1]: https://en.wikipedia.org/wiki/Ansible_(software)
[logo]: https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg "Ansible Logo"
