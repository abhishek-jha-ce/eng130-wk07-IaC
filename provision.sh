#!/bin/bash

# Update and Upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Adding Repositories
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible

# Installing Ansible
sudo apt-get update -y
sudo apt-get install ansible -y
#ansible --version

# Installing Tree
sudo apt install tree

# Configuring Ansible
#sudo cp -f /hosts /etc/ansible/