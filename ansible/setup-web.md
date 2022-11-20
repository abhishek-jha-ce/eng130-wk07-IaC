## Setting up the controller to run the app VM

**Step 1**: We need to copy the files from `app` and `environment` folder to the `controller VM`. This files need to be copied so we can copy it from controller to whereever we need it.

- We copy the files by syncing our local folder in the `Vagrantfile`.

```
   controller.vm.synced_folder "./app", "/home/vagrant/app", create: true
   controller.vm.synced_folder "./environment", "/home/vagrant/environment", create: true
   controller.vm.synced_folder "./yaml", "/home/vagrant/etc/ansible", create: true
```
- We have also copied the `yaml` files, which are inside `yaml` folder. See details below in `YAML` section. These files are called **Playbook**.

**Step 2**: Run Vagrant to setup the three virtual machines.

```
$ vagrant up
```
- It will start up all three Virtual Machine.
- We can individually `ssh` into all the machines.

```
$ vagrant ssh <vm name>
```

**Step 3**: Once we are inside the `controller VM`, we can check if we are connected to the other two VM's. We have given the script to modify the `hosts` file in our `provision.sh` file for Vagrant.

```
# Script inside the provision.sh file

cd /etc/ansible
echo [web] >> hosts
echo 192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts
echo [db] >> hosts
echo 192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts
```
- Check if the script are stored inside the file.
```
vagrant@controller:/etc/ansible$sudo nano hosts
```
- Check if we can ping to other 2 controllers
```
vagrant@controller:/etc/ansible$ sudo ansible all -m ping

192.168.33.11 | FAILED! => {
    "msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."
}
192.168.33.10 | FAILED! => {
    "msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."
}
```
- The 2 Virtual Machines `web` and `db` are not in the known host list, so we can't connect to them. We have to manually log in to them to add them to known list.

- Adding the `web` VM in the known hosts.
```
vagrant@controller:/etc/ansible$ sudo ssh vagrant@192.168.33.10

The authenticity of host '192.168.33.10 (192.168.33.10)' can't be established.
ECDSA key fingerprint is SHA256:cDqQ1xEeETP7fkQ7CGp2xgeabPwYXMItvB8kM/6+mM4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.33.10' (ECDSA) to the list of known hosts.
vagrant@192.168.33.10's password: 
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-163-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue Nov 15 15:57:39 UTC 2022

  System load:  0.0               Processes:           98
  Usage of /:   2.3% of 61.80GB   Users logged in:     0
  Memory usage: 11%               IP address for eth0: 10.0.2.15
  Swap usage:   0%                IP address for eth1: 192.168.33.10


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
```
- Exit from the machine
```
vagrant@web:~$ exit
logout
Connection to 192.168.33.10 closed.
```
- Adding the `db` VM in the known hosts. Repeat the Same Process.

```
vagrant@controller:/etc/ansible$ sudo ssh vagrant@192.168.33.11
The authenticity of host '192.168.33.11 (192.168.33.11)' can't be established.
ECDSA key fingerprint is SHA256:cDqQ1xEeETP7fkQ7CGp2xgeabPwYXMItvB8kM/6+mM4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.33.11' (ECDSA) to the list of known hosts.
vagrant@192.168.33.11's password: 
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-163-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue Nov 15 16:02:07 UTC 2022

  System load:  0.0               Processes:           99
  Usage of /:   2.3% of 61.80GB   Users logged in:     0
  Memory usage: 11%               IP address for eth0: 10.0.2.15
  Swap usage:   0%                IP address for eth1: 192.168.33.11


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento

# Exit from the machine

vagrant@db:~$ exit
logout
Connection to 192.168.33.11 closed.
```

- Now if we ping from the `controller` we can receive response back.

```
vagrant@controller:/etc/ansible$ sudo ansible all -m ping
192.168.33.10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.33.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

## YAML

- YAML is a human-readable data-serialization language. 
- It is commonly used for configuration files and in applications where data is being stored or transmitted. 

### YAML Syntax
- YAML is case sensitive.
- YAML uses indentation to represent scope.
- YAML uses three dashes (---) to indicate the start of a document, and three dots (...) to indicate the end of a document.
- YAML supports two data structures: hashes and arrays.

### YAML for Playbook

- We use YAML file to create Playbooks, **Playbooks** are YAML files containing a list of ordered tasks that should be executed on a remote server to complete a task.

- We create the YAML file inside `/etc/ansible`.

## YAML file (Playbook) for installing `nginx server`

**Step 1**: We create a yaml file called `configure_nginx.yml` to install nginx server.

```
vagrant@controller:/etc/ansible$ sudo nano configure_nginx.yml
```
- The scripts inside the file will contains

```
# Yaml file start
---
# create a script to configure nginx in our web server

# who is the host - name of the server
- hosts: web

# gather data
  gather_facts: yes

# We need admin access
  become: true

# add the actual instruction
  tasks:
  - name: Install/configure Nginx Web server in web-VM
    apt: pkg=nginx state=present

# we need to ensure a the end of the script the status of nginx is running
```

**Step 2**: Run the playbook.

- First check for any syntax errors. Any errors will show up in the terminal.

```
vagrant@controller:/etc/ansible$ sudo ansible-playbook configure_nginx.yml --syntax-check

playbook: configure_nginx.yml
```

- Run the playbook, using the command.

```
vagrant@controller:/etc/ansible$ sudo ansible-playbook configure_nginx.yml
```

- After successfully running the playbook, we get this message.

```
vagrant@controller:/etc/ansible$ sudo ansible-playbook configure_nginx.yml

PLAY [web] ***********************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************
ok: [192.168.33.10]

TASK [Install/configure Nginx Web server in web-VM] ******************************************************************************************
changed: [192.168.33.10]

PLAY RECAP ***********************************************************************************************************************************
192.168.33.10              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

**Step 3**: Check if `nginx` is installed properly using the below commands. Also check the browser using the ip `192.168.33.10`. It will show `nginx` running.

```
vagrant@controller:/etc/ansible$ sudo ansible web -a "systemctl status nginx"

192.168.33.10 | CHANGED | rc=0 >>
● nginx.service - A high performance web server and a reverse proxy server
   Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2022-11-15 16:19:33 UTC; 8min ago
     Docs: man:nginx(8)
 Main PID: 2877 (nginx)
    Tasks: 3 (limit: 1104)
   CGroup: /system.slice/nginx.service
           ├─2877 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
           ├─2882 nginx: worker process
           └─2883 nginx: worker process

Nov 15 16:19:32 web systemd[1]: Starting A high performance web server and a reverse proxy server...
Nov 15 16:19:33 web systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
Nov 15 16:19:33 web systemd[1]: Started A high performance web server and a reverse proxy server.
```

## YAML file (Playbook) for installing `node` and other dependencies

**Step 1**: We create a yaml file called `node.yml` to install node and other related dependencies.

```
vagrant@controller:/etc/ansible$ sudo nano node.yml
```
- The scripts inside the file will contains

```
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

  - name: Install pm2
    npm:
      name: pm2
      global: yes
      #production: yes
      state: present

  - name: Copy app foler into web VM
    synchronize:
      src: /home/vagrant
      dest: /home/vagrant

  - name: Copy environment folder into web VM
    synchronize:
      src: /home/vagrant
      dest: /home/vagrant

  -name: Run npm
    shell:
      cd app
      npm install
      pm2 kill
      pm2 start app.js
```
**Step 2**: Run the playbook.

- First check for any syntax errors. Any errors will show up in the terminal.

```
vagrant@controller:/etc/ansible$ sudo ansible-playbook node.yml --syntax-check

playbook: node.yml
```

- Run the playbook, using the command.

```
vagrant@controller:/etc/ansible$ sudo ansible-playbook node.yml
```

- After successfully running the playbook, we get this message.

```
PLAY [web] **********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Allow all access to tcp port 80] ******************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Add nodejs apt key] *******************************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Add nodejs 12.x ppa for apt repo] *****************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Installing nodejs] ********************************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Install pm2] **************************************************************************************************************************************************************
ok: [192.168.33.10]

TASK [Copy app foler into web VM] ***********************************************************************************************************************************************
changed: [192.168.33.10]

TASK [Copy environment folder into web VM] **************************************************************************************************************************************
changed: [192.168.33.10]

TASK [Run npm] ******************************************************************************************************************************************************************
changed: [192.168.33.10]

PLAY RECAP **********************************************************************************************************************************************************************
192.168.33.10              : ok=9    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

**Step 3**: Check if `node` is installed properly using the below commands from the controller.

```
# Checking the node version
vagrant@controller:/etc/ansible$ sudo ansible web -a "node --version"
192.168.33.10 | CHANGED | rc=0 >>
v12.22.12

# Checking the npm version
vagrant@controller:/etc/ansible$ sudo ansible web -a "npm --version"
192.168.33.10 | CHANGED | rc=0 >>
6.14.16
```

- Check the browser using the ip `192.168.33.10:3000`. It will show the app running. Note: We haven't set the reverse proxy yet.

<p align="center">
   <img src="https://user-images.githubusercontent.com/110366380/201988386-3d423fc9-ffca-4564-86e1-7c0dac8cd833.png">
</p>


**Step 4**: Seed the Database.

- Add the environment variables to the `node.yml` file.
```

- name: Install latest npm & mongoose
  shell: |
      npm install -g npm@latest
      npm install mongoose -y
      
# This one not working      
- name: Add Env varible
    shell: |
      echo export DB_HOST=mongodb://192.168.33.11:27017/posts >> .bashrc
      sudo source .bashrc
```
```
environment:
      DB_HOST: mongodb://192.168.33.11:27017/posts?authSource=admin
    become_user: root
    
# This one not working
 - name: Seed Database
    shell: |
      cd app
      node seeds/seed.js
```
