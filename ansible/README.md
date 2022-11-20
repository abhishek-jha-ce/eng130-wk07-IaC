

# Ansible

Ansible is an open source IT automation tool that automates provisioning, configuration management, application deployment, orchestration, and many other manual IT processes. We can use Ansible automation to install software, automate daily tasks, provision infrastructure, improve security and compliance, patch systems, and share automation across the entire organization.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201702748-e429a4a5-3ea5-4def-9b9e-8a86383661ad.png">
</p>

Ansible works by connecting to what you want automated and pushing programs that execute instructions that would have been done manually. These programs utilize Ansible modules that are written based on the specific expectations of the endpoint’s connectivity, interface, and commands. Ansible then executes these modules (over standard SSH by default), and removes them when finished (if applicable).

## Configuration Management with Ansible

- **Ansible** can be used for both *Orchestration* and *Configuration Management*, but we use it mostly for *Configuration Management* as it is possible but not easy to do *Orchestration* compared to using other *Orchestration* tools like **Terraform**.

<p align="center">
  <img height=500 width=750 src="https://user-images.githubusercontent.com/110366380/201694444-ddb5beff-753e-4c8d-ae3e-d718b90ac772.png">
</p>

### Inventory
- Inventory is a list of hosts that ansible manages. It is a simple text file named `hosts` that contains a list of hosts. It can also contain groups of hosts and variables that apply to those hosts.

- Ansible reads information about the machine we manage from the `hosts` file also called inventory .

Example of an inventory file:
```
---
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```
### Roles

- Roles let us automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure. After we group our content in roles, we can easily reuse them and share them with other users.

- Roles may also include `modules` and other plugin types in a directory called `library`.

### Modules

- Modules are basically the small programs in ansible that does the actual work. 
- They are script-like programs written to specify the desired state of the system.
- They are part of larger program called Playbook
- Ansible moduels can also be defined as a standalone script that can be used inside an `Ansible Playbook`.

Example of a Module:
```
- name: Install pm2
    npm:
      name: pm2
      global: yes
      #production: yes
      state: present
```

### Playbook

- Ansible Playbooks offer a repeatable, re-usable, simple configuration management and multi-machine deployment system.
- It is well suited to deploy complex applications. 
- If we need to execute a task with Ansible more than once, we can write a playbook and put it under source control. 
- We can then use the playbook to push out new configuration or confirm the configuration of remote systems.
- They are written in `YAML`.

Example of Playbook:
```
# Start of file
---

# Name of Server
- hosts: web

# Gather Data
  gather_facts: yes

# To execute the corresponding task as a sudo user root unless specified any other user with become_user
  become: true
tasks:
  - name: Allow all access to tcp port 80
    ufw:
      rule: allow
      port: '80'
      proto: tcp

  - name: Add nodejs apt key
    apt_key:
      url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
      state: present

  - name: "Add nodejs 12.x ppa for apt repo"
    apt_repository:
      repo: deb https://deb.nodesource.com/node_12.x bionic main
      update_cache: yes
```
