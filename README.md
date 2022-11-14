# Blue Green Deployment

Blue green deployment is an application release model that gradually transfers user traffic from a previous version of an app or microservice to a nearly identical new release—both of which are running in production. 

The old version can be called the blue environment while the new version can be known as the green environment. Once production traffic is fully transferred from blue to green, blue can standby in case of rollback or pulled from production and updated to become the template upon which the next update is made.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201677033-655ac493-8a5b-42f0-9cf8-16c42c74b8e7.png">
</p>


Once the new software is deployed to the system in which we plan to run it, we execut a smoke test to check the software is working properly. If the test passes, we would cut traffic over to the new deployment by reconfiguring the proxy [ Apache or similar].

# Infrastructure as Code

Infrastructure as Code (IaC) is the managing and provisioning of infrastructure through code instead of through manual processes.

With IaC, configuration files are created that contain our infrastructure specifications, which makes it easier to edit and distribute configurations. It also ensures that we provision the same environment every time.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201673974-caa11261-34bb-46db-b5f9-042169b1501e.png">
</p>

## Configuration Management

Configuration management refers to the process by which all environments hosting software are configured and maintained. It is the process of maintaining systems, such as computer hardware and software, in a desired state. Configuration Management (CM) is also a method of ensuring that systems perform in a manner consistent with expectations over time.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201694444-ddb5beff-753e-4c8d-ae3e-d718b90ac772.png">
</p>


## Orchestration

DevOps orchestration is the automation of numerous processes that run concurrently in order to reduce production issues and time to market, while automation is the capacity to do a job or a series of procedures to finish an individual task repeatedly.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201700821-4dfa6620-b437-4d81-a103-2ecc20a3270a.png">
</p>

## Ansible

Ansible is an open source IT automation tool that automates provisioning, configuration management, application deployment, orchestration, and many other manual IT processes. We can use Ansible automation to install software, automate daily tasks, provision infrastructure, improve security and compliance, patch systems, and share automation across the entire organization.

<p align="center">
  <img src="https://user-images.githubusercontent.com/110366380/201702748-e429a4a5-3ea5-4def-9b9e-8a86383661ad.png">
</p>
