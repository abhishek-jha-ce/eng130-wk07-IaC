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
  <img src="https://user-images.githubusercontent.com/110366380/201675173-4b8077fe-8679-4b2c-84d0-de012951f334.png">
</p>

## Orchestration

DevOps orchestration is the automation of numerous processes that run concurrently in order to reduce production issues and time to market, while automation is the capacity to do a job or a series of procedures to finish an individual task repeatedly.
