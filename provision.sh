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