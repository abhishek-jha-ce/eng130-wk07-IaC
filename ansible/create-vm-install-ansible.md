## Architecture Diagram:

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/202917600-bac73719-2981-46c2-86e2-620c6b5e617a.png">    
</p>
  
## Getting the VM up an running with Vagrant file

### Requirement:

We need three virtual machine
- Controller - To host our ansible controller
- Web - To host our Web App.
- DB - To host our Database.

- We setup these three virtual machine using `Vagrant`. The `Vagrantfile` to steup the three VM:

```
 # All Vagrant configuration is done below. The "2" in Vagrant.configure
 # configures the configuration version (we support older styles for
 # backwards compatibility). Please don't change it unless you know what
 
 # MULTI SERVER/VMs environment 
 
 Vagrant.configure("2") do |config|
 
 # creating first VM for Ansible controller
   config.vm.define "controller" do |controller|
     
    controller.vm.box = "bento/ubuntu-18.04"
    
    controller.vm.hostname = 'controller'
    
    controller.vm.network :private_network, ip: "192.168.33.12"
       
   end 
 
 # creating second VM called web  
   config.vm.define "web" do |web|
     
     web.vm.box = "bento/ubuntu-18.04"
    # downloading ubuntu 18.04 image
 
     web.vm.hostname = 'web'
     # assigning host name to the VM
     
     web.vm.network :private_network, ip: "192.168.33.10"
         
   end
   
 # creating third VM called db
   config.vm.define "db" do |db|
     
     db.vm.box = "bento/ubuntu-18.04"
     
     db.vm.hostname = 'db'
     
     db.vm.network :private_network, ip: "192.168.33.11"
        
   end
  
 end

```

- After running `vagrant up`, we should have 3 virtual machines successfully running.

- Now, we can `SSH` into the machine and then do update and upgrade, individually. These also make sure we have internet connection.

```
$ vagrant ssh controller
vagrant@controller:~$ sudo apt-get update
vagrant@controller:~$ sudo apt-get upgrade -y

$ vagrant ssh web
vagrant@web:~$ sudo apt-get update
vagrant@web:~$ sudo apt-get upgrade -y

$ vagrant ssh db
vagrant@controller:~$ sudo apt-get update
vagrant@controller:~$ sudo apt-get upgrade -y

```

## Setting up the Ansible Controller

- To set up the controller machine, we first need to install ansible. We have to install some **dependencies** related to `python` that are needed for `ansible`.

```
sudo apt-get install software-properties-common #
sudo apt-add-repository ppa:ansible/ansible # add the name of the repository for ansible
```

### Installing Ansible in Controller
- Run an update, before installing `Ansible`.

```
sudo apt-get update # Update
sudo apt-get install ansible -y # Install Ansible

ansible --version # Check Version, if ansible is installed properly

sudo apt install tree  # To view directory structured in an organised view, nothing to do with ansible
```

## Default folder/file Structure

- /etc/ansible
- Inside this directory, `hosts` file contains the `ip address` of our agent nodes.

```
vagrant@controller:/etc/ansible$ ls
ansible.cfg    hosts    roles
```

## SSH into Nodes from Controller

- Instead of using the SSH with SSH keys, we are using SSH with a password for this instance.

### Connect to the Web from Controller

```
sudo ssh vagrant@192.168.33.10 # IP Address of Web

#It will ask for a password
#For the first time it will ask to permanently add the host as well showing the key as well.

The authenticity of host '192.168.33.10 (192.168.33.10)' can't be established.
ECDSA key fingerprint is SHA256:cDqQ17fkQ7CGp2xgeabPwYXMItvB8kM/6+mM4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.33.10' (ECDSA) to the list of known hosts.
vagrant@192.168.33.10's password: vagrant

vagrant@web:~$
```
### Connect to the DB from Controller
```
sudo ssh vagrant@192.168.33.11 # IP Address of DB

#It will ask for a password.
vagrant@192.168.33.11's password: vagrant

vagrant@db:~$
```


## Adding Hosts in the Controller

- We will SSH into the host machine using a password, instead of the key.
- We have to explicitly define the username and password in the host file to enable a successful connection.

```
sudo nano /etc/hosts

Inside the file, provide the ip address, connection type, username and password

[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```

## Ping from the Controller

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
## Ad-hoc Commands

- Ad hoc commands are commands which can be run individually to perform quick functions. It is run on command-line to automate a single task on one or more managed nodes.

```
sudo ansible web -a "date"              # Show the date of the machine
ansible all -m ping                     # Ping all hosts
ansible web -m ping                     # Ping web hosts
ansible db -m ping                      # Ping db hosts
ansible all -a "free"                   # Find free memory
sudo ansible all -a "sudo apt update"   # to update all 
ansible all -a "uname -a"               # Prints the name, version and other details about the machine and the OS running.
```

## Copying file from controller to server nodes

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
