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

### Create Auto Scaling Policy
```
# Create Auto Scaling Policy - Increased Usage
resource "aws_autoscaling_policy" "tf-autoscaling-up"{
    name = var.autoscaling_policy_name_up
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.tf-auto-scaling-group.name}"
}
```

### Create Cloud Watch metrics
```
resource "aws_cloudwatch_metric_alarm" "tf-cpu-alarm-up" {
    alarm_name = var.cpu_alarm_up
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CUPUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "70"

    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.tf-auto-scaling-group.name}"
    }

    alarm_description = "This metric monitor EC2 instance CPU utilization"
    alarm_actions = ["${aws_autoscaling_policy.tf-autoscaling-up.arn}"]
}

# Create Auto Scaling Policy - Decreased Usage
resource "aws_autoscaling_policy" "tf-autoscaling-down"{
    name = var.autoscaling_policy_name_down
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.tf-auto-scaling-group.name}"
}

resource "aws_cloudwatch_metric_alarm" "tf-cpu-alarm-down" {
    alarm_name = var.cpu_alarm_down
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CUPUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "30"

    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.tf-auto-scaling-group.name}"
    }

    alarm_description = "This metric monitor EC2 instance CPU utilization"
    alarm_actions = ["${aws_autoscaling_policy.tf-autoscaling-down.arn}"]
}

```
