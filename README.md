[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README_PT-BR.md)

# Docker Activity

Repository for the Docker activity, part of the Compass UOL scholarship program.

**Objective**: Set up an environment on AWS with a Load Balancer that directs traffic to an EC2 instance containing a Docker container running WordPress. The static resources of the container will be stored in an Elastic File System (EFS), while the WordPress data will be managed by the Amazon RDS service.

**Scope**: The project scope encompasses a series of interconnected steps to achieve the proposed objective:

- Initial Preparation:
Generate an SSH public key to establish secure access to the instances.

- Infrastructure Creation:
Create EC2 instances based on the Amazon Linux 2 image, intended to host the WordPress application.
Configure security groups to allow HTTP/HTTPS and SSH communications.
Associate an Elastic IP address with each instance, ensuring a stable access point.
Implement a Load Balancer to distribute traffic among the EC2 instances.

- EFS File System Configuration:
Establish an EFS file system dedicated to storing the static resources of WordPress.
Mount the EFS file system on the EC2 instances, enabling resource sharing among instances.

- Docker Compose Configuration for WordPress:
Develop a docker-compose.yml file used to define and configure the WordPress environment.
Adapt the Docker Compose to integrate the static resources of the EFS file system.

- Integration with Amazon RDS:
Configure an Amazon RDS instance to store and manage essential data for WordPress operation.
Adjust WordPress settings to allow connection and interaction with the Amazon RDS database.

- Automation and Monitoring:
Develop a startup script with the purpose of automatically mounting the EFS file system.
Configure a monitoring system capable of identifying and alerting about potential failures in the EC2 instances.
Implement a validation script to continuously check the availability of the WordPress service, issuing alerts in case of unavailability.

- Documentation:
Create a detailed instruction guide, describing step by step the configuration and deployment of the WordPress environment.
Provide clear and comprehensive documentation of the relevant steps for monitoring and solving any issues that may arise in the environment.

By fulfilling this scope, the project will ensure a highly reliable and scalable environment capable of hosting a WordPress site, with static resources efficiently stored and data management ensured by Amazon RDS. The Load Balancer will contribute to balanced traffic distribution, while automation and monitoring will aid in maintaining service availability.

**Referências**: [Amazon Web Services Documentation](https://docs.aws.amazon.com/pt_br/index.html), [Amazon Linux 2 Documentation](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Docker Documentation](), [Docker-Compose Documentation.]().