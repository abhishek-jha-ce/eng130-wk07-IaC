## Setting up the controller to run the db VM

## Create a YAML file for database

**Step 1** - Create a yaml file called `mongo.yml`.

```
vagrant@controller:/etc/ansible$ sudo nano mongo.yml
```

- The scripts inside the file contains
```
---
# host is our db

- hosts: db

  gather_facts: yes

  become: true

  tasks:
  - name: install mongodb
    apt: pkg=mongodb state=present
    
  - name: Remove mongodb file (delete file)
    file:
      path: /etc/mongodb.conf
      state: absent
      
  - name: Create the file with read permission and user have write permission
    file:
      path: /etc/mongodb.conf
      state: touch
      mode: u=rw,g=r,o=r
      
  - name: Insert multiple lines and Backup
    blockinfile:
      path: /etc/mongodb.conf
      
      block: |
        storage:
          dbPath: /var/lib/mongodb
          journal:
            enabled: true
            
        systemLog:
          destination: file
          logAppend: true
          path: /var/log/mongodb/mongod.log
          
        net:
          port: 27017
          bindIp: 0.0.0.0
          
  - name: Restart mongodb
    become: true
    shell: systemctl restart mongodb
    
  - name: enable mongodb
    become: true
    shell: systemctl enable mongodb
    
  - name: start mongodb
    become: true
    shell: systemctl start mongodb
```
**Step 2**: Run the playbook.

- First check for any syntax errors. Any errors will show up in the terminal.
```
vagrant@controller:/etc/ansible$ sudo ansible-playbook mongo.yml --syntax-check

playbook: mongo.yml
```
- Run the playbook, using the command:
```
vagrant@controller:/etc/ansible$ sudo ansible-playbook mongo.yml
```
- After successfully running the playbook, we get this message.
```
PLAY [db] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************

TASK [Touch a file, using symbolic modes to set the permissions (equivalent to 0644)] *******************************************************************************************
changed: [192.168.33.11]

TASK [Insert multiple lines and Backup] *****************************************************************************************************************************************
changed: [192.168.33.11]

TASK [Restart mongodb] **********************************************************************************************************************************************************
changed: [192.168.33.11]

TASK [enable mongodb] ***********************************************************************************************************************************************************
changed: [192.168.33.11]

TASK [start mongodb] ************************************************************************************************************************************************************
changed: [192.168.33.11]

PLAY RECAP **********************************************************************************************************************************************************************
192.168.33.11              : ok=8    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

**Step 3**: Check if `mondodb` is installed properly, by checking its version.
```
vagrant@controller:/etc/ansible$ sudo ansible db -a "mongod --version"

192.168.33.11 | CHANGED | rc=0 >>
db version v3.6.3
git version: 9586e557d54ef70f9ca4b43c26892cd55257e1a5
OpenSSL version: OpenSSL 1.1.1  11 Sep 2018
allocator: tcmalloc
modules: none
build environment:
    distarch: x86_64
    target_arch: x86_64
```
- We can also check for the status of `mongodb`.

```
vagrant@controller:/etc/ansible$ sudo ansible db -a "sudo systemctl status mongodb"

192.168.33.11 | CHANGED | rc=0 >>
● mongodb.service - An object/document-oriented database
   Loaded: loaded (/lib/systemd/system/mongodb.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2022-11-15 18:08:50 UTC; 7min ago
     Docs: man:mongod(1)
 Main PID: 14342 (mongod)
    Tasks: 23 (limit: 1104)
   CGroup: /system.slice/mongodb.service
           └─14342 /usr/bin/mongod --unixSocketPrefix=/run/mongodb --config /etc/mongodb.conf

Nov 15 18:08:50 db systemd[1]: Started An object/document-oriented database.
```

**Step 4**: Check the `mongodb.conf` file to see if access is allowed to all IP i.e. `bindIp: 0.0.0.0` for `Port: 27017`. 

```
vagrant@controller:~$ sudo ansible db -a "cat /etc/mongodb.conf"

192.168.33.11 | CHANGED | rc=0 >>
# BEGIN ANSIBLE MANAGED BLOCK
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 0.0.0.0
# END ANSIBLE MANAGED BLOCK
```

## Install the latest npm and Mongoose

- We will need the latest node package manager.
- We will also need mongoose, which is the Object Data Modelling library for Mongo DB.
- *Note* - We will need node v14 or above for the latest version of npm and mongoose to work.

```
- name: download latest npm + Mongoose
    shell: |
      npm install -g npm@latest
      npm install mongoose -y
```

## Seed the database and add Environment variable

- Add the environment variables to the `node.yml` file.
- Seed the database before starting the app.

```
 - name: Run npm and Seed Database
    shell: |
      cd app
      npm install
      node seeds/seed.js
      pm2 kill
      pm2 start app.js
    environment:
      DB_HOST: mongodb://192.168.33.11:27017/posts?authSource=admin
    become_user: root
```

- Now if we run `http://192.168.33.10:3000/posts` we can see that we are successfully connected to the database:


![image](https://user-images.githubusercontent.com/110366380/202935415-bea85fee-10f9-4abb-8318-d2d3c6076498.png)



