## Setting up reverse proxy for nginx

- Ensure the `node-app` and `mongodb` required depndencies are available in the specified location.
- Edit the existing `configure-nginx.yml` file and replace the code as follow:

```
#nginx setup playbook on web with reverse proxy


 - hosts: web
    
      gather_facts: true
    
      become: true
    
      tasks:
      - name: Install nginx
        apt: pkg=nginx state=present
        become_user: root
    
      - name: Remove nginx default file (delete file)
        file:
          path: /etc/nginx/sites-enabled/default
          state: absent
    
      - name: Touch a file, using symbolic modes to set the permissions (equivalent to 0644)
        file:
          path: /etc/nginx/sites-enabled/reverseproxy.conf
          state: touch
          mode: '666'
    
    
      - name: Insert multiple lines and Backup
        blockinfile:
          path: /etc/nginx/sites-enabled/reverseproxy.conf
          block: |
            server{
              listen 80;
              server_name development.local;
              location / {
                  proxy_pass http://127.0.0.1:3000;
              }
            }
      - name: Create a symbolic link
        file:
          src: /etc/nginx/sites-enabled/reverseproxy.conf
          dest: /etc/nginx/sites-available/reverseproxy.conf
          state: link
    
      - name: nginx bug workaround
        shell: |
          sudo mkdir /etc/systemd/system/nginx.service.d
            printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" | \
              sudo tee /etc/systemd/system/nginx.service.d/override.conf
          sudo systemctl daemon-reload
          sudo systemctl restart nginx
  ```
  
  - The reverse proxy is working successfully, as we can see that we don't need to use `port 3000` to access the app.  

![image](https://user-images.githubusercontent.com/110366380/202937295-ac06657d-214c-49ae-a463-f83683900828.png)

