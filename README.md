# Blue Green Deployment

Blue green deployment is an application release model that gradually transfers user traffic from a previous version of an app or microservice to a nearly identical new release—both of which are running in production. 

The old version can be called the blue environment while the new version can be known as the green environment. Once production traffic is fully transferred from blue to green, blue can standby in case of rollback or pulled from production and updated to become the template upon which the next update is made.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201677033-655ac493-8a5b-42f0-9cf8-16c42c74b8e7.png">
</p>


Once the new software is deployed to the system in which we plan to run it, we execut a smoke test to check the software is working properly. If the test passes, we would cut traffic over to the new deployment by reconfiguring the proxy [ Apache or similar].

## Benefits

- Rapid release
- Simple rollbacks
- Built-in Diastaster Recovery
- Load Balancing

# Infrastructure as Code

Infrastructure as Code (IaC) is the managing and provisioning of infrastructure through code instead of through manual processes.

With IaC, configuration files are created that contain our infrastructure specifications, which makes it easier to edit and distribute configurations. It also ensures that we provision the same environment every time.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201673974-caa11261-34bb-46db-b5f9-042169b1501e.png">
</p>

## Configuration Management

Configuration management refers to the process by which all environments hosting software are configured and maintained. It is the process of maintaining systems, such as computer hardware and software, in a desired state. Configuration Management (CM) is also a method of ensuring that systems perform in a manner consistent with expectations over time.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201706750-7b8743d6-bd46-4b02-ace3-c251536a7936.png">
</p>


## Orchestration

DevOps orchestration is the automation of numerous processes that run concurrently in order to reduce production issues and time to market, while automation is the capacity to do a job or a series of procedures to finish an individual task repeatedly.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201700821-4dfa6620-b437-4d81-a103-2ecc20a3270a.png">
</p>

## Ansible

Ansible is an open source IT automation tool that automates provisioning, configuration management, application deployment, orchestration, and many other manual IT processes. We can use Ansible automation to install software, automate daily tasks, provision infrastructure, improve security and compliance, patch systems, and share automation across the entire organization.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201702748-e429a4a5-3ea5-4def-9b9e-8a86383661ad.png">
</p>

Ansible works by connecting to what you want automated and pushing programs that execute instructions that would have been done manually. These programs utilize Ansible modules that are written based on the specific expectations of the endpoint’s connectivity, interface, and commands. Ansible then executes these modules (over standard SSH by default), and removes them when finished (if applicable).

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201694444-ddb5beff-753e-4c8d-ae3e-d718b90ac772.png">
</p>

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
