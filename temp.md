code snippets
```
vagrant@controller:/etc/ansible$ cat node.yml
# Start of file
---

# Name of Server
- hosts: web

# Gather Data
  gather_facts: yes

# To execute the corresponding task as a sudo user root unless specified any other user with become_user
  become: true

# Create a Script to configure/install/set up Required version of nodejs

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

  - name: Installing nodejs
    apt:
      update_cache: yes
      name: nodejs
      state: present

#  - name: Install npm
#    apt: pkg=npm state=present

  - name: Install pm2
    npm:
      name: pm2
      global: yes
      production: yes
      state: present

#  - name: Copy "app" folder from localhost to remote app vm
#    copy:
#      src: ~/Sparta/resources/app
#      dest: /home/vagrant/app
#      remote_src: yes

# Copy Dependencies from localhost to controller/web using playbook


```


# Mongo DB

```
---
#
- hosts: db

  gather_facts: yes

  become: true

  tasks:
  - name: install mongodb
    apt: pkg=mongodb state=present
```
