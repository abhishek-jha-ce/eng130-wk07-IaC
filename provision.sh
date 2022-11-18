#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install software-properties-common

# ensure line 3 executes in the script
sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update -y 
sudo apt-get install ansible -y

#to check if setup properly
# ansible --version

#to install tree -to view folder structure in a nice way
sudo apt-get install tree

# Doing it manually in hosts file in this iteration - These will append the following 4 lines of code in the hosts file
# cd /etc/ansible
# echo [web] >> hosts
# echo 192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts
# echo [db] >> hosts
# echo 192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant >> hosts