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

## Use-case

- Public Cloud Provisioning
- MultiCloud Deployments
- Bespoke Infrastructure As Code

## Who is using it
Companies like Uber, Udemy, Slack, Twitch.

## Who owns Terraform
