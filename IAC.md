# Infrastructure as Code (IaC)

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/202722822-0361abdd-fcde-4be6-b0c4-ca945d88b7c8.png">
</p>


### Providing User Data

```
data "template_file" "user_data_lt" {
    template = <<EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install nginx -y
    sudo systemctl restart nginx
    sudo systemctl enable nginx
    EOF
}
```

### Creating Launch Template
```
resource "aws_launch_template" "tf-launch-template"{
    name = var.launch_template_name
    image_id = var.webapp_ami_id
    instance_type = var.ec2_type
    key_name = var.aws_key_name
    vpc_security_group_ids = ["${aws_security_group.tf-public-sg.id}"]
    user_data = "${base64encode(data.template_file.user_data_lw.rendered)}"
    tags = {
        Name = var.launch_template_name
    }
}
```
