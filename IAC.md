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
    # vpc_security_group_ids = ["${aws_security_group.tf-public-sg.id}"] # Don't use this one, Create a new one.
    user_data = "${base64encode(data.template_file.user_data_lw.rendered)}"
    tags = {
        Name = var.launch_template_name
    }
}
```

### Create Auto Scaling Group
```
# Create autoscaling group
resource "aws_autoscaling_group" "tf-auto-scaling-group"{
    name = var.autoscaling_group_name
    availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    desired_capacity = 2
    max_size = 3
    min_size = 2

    launch_template {
      id = "${aws_launch_template.tf-launch-template.id}" 
    }
}
```
