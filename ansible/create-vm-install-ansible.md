
## Default folder/file Structure

- /etc/ansible
- Inside this directory, `hosts` file contains the `ip address` of our agent nodes.

## Getting the machines up an running from Vagrant file

```
Vagrant SSH

We should have 3 Virtual Machines: Controller, Web and DB
```

## Installing Ansible in Controller

```
sudo apt-get install software-properties-common #
sudo apt-add-repository ppa:ansible/ansible #

sudo apt-get update # Update
sudo apt-get install ansible # Install Ansible

ansible --version # Check Version, if ansible is installed properly

sudo apt install tree  # To view directory structured in an organised view
```

### Connect to the Web from Controller

sudo ssh vagrant@192.168.33.10 # IP Address of Web
password: vagrant

### Connect to the DB from Controller

sudo ssh vagrant@192.168.33.11 # IP Address of DB
password: vagrant

### Adding Hosts to Controller

```
sudo nano /etc/hosts

Inside the file, provide the ip address, connection type, username and password

[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

```

### Ping from the Controller

```
ansible all -m ping
```

Output if no errors:
```
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

### Copying `hosts` file

- Copying `hosts` file from `controller` VM to `web` VM.

```
vagrant@controller:/etc/ansible$ sudo ansible web -m copy -a "src=hosts dest=/home/vagrant"

vagrant@controller:/etc/ansible$ sudo ansible db -m copy -a "src=hosts dest=/home/vagrant"
```
- We can see that the files have been successfully copied.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201709972-1c3e9521-636f-40ba-8303-930bb5902ffe.png">
  <img src="https://user-images.githubusercontent.com/110366380/201710647-1dbd9148-fcbe-4c81-9f51-3e0c1d89cff7.png">
</p>

### Other Commands

```
sudo ansible web -a "date" # to show the date of the machine
sudo ansible all -m ping # to ping all the machines
sudo ansible all -a "sudo apt update" # to update all 
ansible all -a "uname -a" # Prints the name, version and other details about the machine and the OS running.
```

## Setting up `provision.sh`

```
#!/bin/bash
sudo apt-get update -y
sudo apt-get install software-properties-common -y

# ensure line 3 executes in the script
sudo apt-add-repository ppa:ansible/ansible -y

sudo apt-get upgrade -y 
sudo apt-get install ansible -y

#to check if setup properly
ansible --version

#to install tree -to view folder structure in a nice way
sudo apt-get install tree

cd /etc/ansible
echo [web] >> hosts
echo 192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts
echo [db] >> hosts
echo 192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts
```
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
