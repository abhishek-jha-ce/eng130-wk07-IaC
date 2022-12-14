# Infrastructure as Code - Orchestration with Terraform

## Terraform

Terraform is an open-source software tool that allows us to safely and predictably manage infrastructure at scale using cloud-agnostic and infrastructure as code principles. It is a powerful tool developed by **Hashicorp** that enables infrastructure provisioning both on the cloud and on-premises.

- It is an infrastructure as code tool that lets us define infrastructure resources in human-readable configuration files.
- It is written in a declarative configuration language, Hashicorp Configuration Language (HCL).
- It facilitates the automation of infrastructure management in any environment.
- It allows us to collaborate and perform changes safely on cloud environments and scale them on-demand according to the business needs.


![image](https://user-images.githubusercontent.com/110366380/202415366-7ecc33f8-ad56-4ab5-9f56-44cf5ceafcec.png)



## Benefits

- Terraform is OpenSource, platform-agnostic i.e. can be used in any cloud.
- Terraform is Declarative i.e it describes an intended goal rather than the exact steps needed to reach that goal.
- Terraform is Agentless i.e. no need to install agent software on each server that we want to configure.
- Terraform uses a modular structure i.e. Terraform modules are a powerful way to reuse code and stick to the "DRY" principle.
- Terraform has a large community with enterprise support options. It has the most active ecosystem, according to stack overflow.

![image](https://user-images.githubusercontent.com/110366380/202416490-205474eb-48b9-4d68-b316-679f182a5c04.png)

## Terraform Module
- Terraform modules are comparable to functions in programming languages.
- Using modules we have a standard interface for creating resources by providing inputs and returning outputs.
- It help us to organize configuration, encapsulate configuration, re-use configuration, provide consistency and ensure best practices.

## Terraform State
## Use-case

- Public Cloud Provisioning
- MultiCloud Deployments
- Bespoke Infrastructure As Code

## Who is using it
Companies like Uber, Udemy, Slack, Twitch.

## Who owns Terraform

- Terraform Commands

```
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.

```


- `main.tf` file

```
# Write a script to launch resources on the cloud
# syntax {
#         key = value  }
# Create EC2 instance on AWS

# Download dependencies from AWS

provider "aws" {
# Which part of AWS we would like to launch resources in
  region = "eu-west-1"
}
# What type of server with what sort of functionality

# add resource

# ami

# instance type

# do we need public ip or not

# name the server

# launch an instance
resource "aws_instance" "app_instance" {
  ami = "ami-0b47105e3d7fc023e"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags = {
      Name = "eng130-abhishek-terraform-app"     
  }
}
```

## Architecture

![Untitled Diagram drawio(2)](https://user-images.githubusercontent.com/110366380/202481178-4f50f1b1-8f71-455c-9d08-f1d04268e275.png)

```
# Write a script to launch resources on the cloud
# syntax {
#         key = value  }
# Create EC2 instance on AWS

# Download dependencies from AWS


provider "aws" {
# Which part of AWS we would like to launch resources in
  region = var.region
}

# Creating the VPC
resource "aws_vpc" "tf-vpc" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tf-igw" {
    vpc_id = "${aws_vpc.tf-vpc.id}"
    tags = {
        Name = var.igw_name
    }
}

# Create a public subnet
resource "aws_subnet" "tf-public-subnet"{
    vpc_id = "${aws_vpc.tf-vpc.id}"
    cidr_block = var.public_subnet_cidr_block
    map_public_ip_on_launch = "true" // To make it a public subnet
    availability_zone = var.availability_zone
    tags = {
        Name = var.public_subnet_name
    }
}

# Create custom route table
resource "aws_route_table" "tf-public-rt" {
    vpc_id = "${aws_vpc.tf-vpc.id}"
    
    route {
        cidr_block = var.allow_all_cidr_block         
        gateway_id = "${aws_internet_gateway.tf-igw.id}" 
    }
    
    tags = {
        Name = var.public_route_table_name
    }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "tf-rt-public-subnet"{
    subnet_id = "${aws_subnet.tf-public-subnet.id}"
    route_table_id = "${aws_route_table.tf-public-rt.id}"
}

# Create Securit Group for the public subnet
resource "aws_security_group" "tf-public-sg" {
    name = var.public_security_group_name
    vpc_id = "${aws_vpc.tf-vpc.id}"
    
    # Outgoing Traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [var.allow_all_cidr_block]
    }    
    
    # Incoming Traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"        
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.allow_all_cidr_block]
    }

    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = [var.allow_all_cidr_block]
    }    
    
    tags = {
        Name = var.public_security_group_name
    }
}

# launch an instance
resource "aws_instance" "app_instance" {
  ami =  var.webapp_ami_id
  instance_type = var.ec2_type

  # VPC
  subnet_id = "${aws_subnet.tf-public-subnet.id}"

  # Security Group
  vpc_security_group_ids = ["${aws_security_group.tf-public-sg.id}"]

  associate_public_ip_address = true
  
  tags = {
      Name = var.name     
  }  
}
```
