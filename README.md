[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README.md)   [![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/README_PT-BR.md)

# Docker Activity

Repository for the Docker activity, part of the Compass UOL scholarship program.

**Objective**: Set up an environment on AWS with a Load Balancer that directs traffic to an EC2 instance containing a Docker container running WordPress. The static resources of the container will be stored in an Elastic File System (EFS), while the WordPress data will be managed by the Amazon RDS service.

**Scope**: The project scope encompasses a series of interconnected steps to achieve the proposed objective:

- Initial Preparation:
Generate an SSH public key to establish secure access to the instances.

- Infrastructure Creation:
Create EC2 instances based on the Amazon Linux 2 image, intended to host the application.
Configure security groups to allow HTTP/HTTPS and SSH communications.
Associate an Elastic IP address with each instance, ensuring a stable access point.
Implement a Load Balancer to distribute traffic among the EC2 instances.

- EFS File System Configuration:
Establish an EFS file system dedicated to storing the static resources.
Mount the EFS file system on the EC2 instances, enabling resource sharing among instances.

- Docker Compose Configuration for WordPress:
Develop a docker-compose.yml file used to define and configure the WordPress environment.
Adapt the Docker Compose to integrate the static resources of the EFS file system.

- Integration with Amazon RDS:
Configure an Amazon RDS instance to store and manage essential data for WordPress operation.
Adjust WordPress settings to allow connection and interaction with the Amazon RDS database.

- Automation:
Develop a startup script with the purpose of automatically mounting the EFS file system.

- Documentation:
Create a detailed instruction guide, describing step by step the configuration and deployment of the WordPress environment.
Provide clear and comprehensive documentation of the relevant steps for monitoring and solving any issues that may arise in the environment.

By fulfilling this scope, the project will ensure a highly reliable and scalable environment capable of hosting a WordPress site, with static resources efficiently stored and data management ensured by Amazon RDS. The Load Balancer will contribute to balanced traffic distribution, while automation will aid in maintaining service availability.

**Project Architecture**:

![PROJECT_ARCHITECTURE](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/PROJECT_ARCHITECTURE.png)

**References**: [Amazon Web Services Documentation](https://docs.aws.amazon.com/pt_br/index.html), [Amazon Linux 2 Documentation](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html), [Docker Documentation](https://docs.docker.com/), [Docker-Compose Documentation.](https://docs.docker.com/compose/).

---
## Step by Step

### Creating a VPC
- In AWS, search for `VPC`.

![VPC_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_APP.png)

- In the VPC menu, click on `Create VPC`.

- When creating the VPC, select to create a NAT Gateway.

- Detailed instructions on how to create a VPC can be found [Here](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README.md#creating-a-vpc)

<details>
<summary>Add NAT Gateway after creating the VPC</summary>

- After creating the VPC, still in the menu, go to `NAT Gateways`.

- Click on `Create NAT Gateway`.

- Name the NAT Gateway and in `Subnet` select one of the public subnets.

- Keep `Connectivity type` as public.

- Then click on `Create NAT Gateway`.

- After creating the NAT gateway, access `Route Tables`.

- In the `Route Table`, select the private routes, click on `Actions`, and select `Edit routes`. This needs to be done for both routes.

- In `Edit routes`, for `Destination`, select `0.0.0/0`.

- For the Target, select `NAT Gateway` and choose the previously created NAT gateway.

- Click on `Save changes`.

</details>

To verify if your VPC is correct, access `Your VPCs`, then select the previously created VPC and choose the `Resource map` option. Check if it matches the image below.

![VPC_MAP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_MAP.png)

### Creating Security Groups
- In the EC2 menu, search for `Security groups` in the left navigation bar.

![SC_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/SC_BARRA.png)

- Access it and click on `Create security group`, and create the following security groups.

- Detailed instructions on how to create a security group can be found [Here](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README.md#creating-a-security-group)

#### EFS
| Type | Protocol | Port Range | Source | Description |
| ---|---|---|---|--- |
| Custom TCP | TCP | 2049 | 0.0.0.0/0 | NFS |
| Custom UDP | UDP | 2049 | 0.0.0.0/0 | NFS |

#### EC2
| Type | Protocol | Port Range | Source | Description |
| ---|---|---|---|--- |
| SSH | TCP | 22 | 0.0.0.0/0 | SSH |
| Custom TCP | TCP | 80 | 0.0.0.0/0 | HTTP |
| Custom TCP | TCP | 443 | 0.0.0.0/0 | HTTPS |

#### RDS
| Type | Protocol | Port Range | Source | Description |
| ---|---|---|---|--- |
| Custom TCP | TCP | 3306 | 0.0.0.0/0 | RDS |

#### Endpoint

- Allow only outbound connections.

### Creating an EFS
- Search for `EFS` in Amazon AWS, the scalable NFS file service of AWS.

![EFS_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EFS_APP.png)

- On the EFS page, click on `Create file system`.

- Detailed instructions on how to create an EFS can be found  [Here](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README.md#criando-um-efsnsf-server), which provides specific guidance. Make sure to use the security group that was created earlier to ensure security settings.

### Creating RDS
- Search for RDS in Amazon AWS.

![RDS_APP](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/RDS_APP.png)

- On the RDS page, click on `Create database`.

- On the `Create database` page, select `Standard creation`.

- Under `Engine options`, select `MySQL`.

- For `Engine version`, choose `MySQL 8.0.33`.

- Under `Templates`, select `Free tier`.

- In the `Configuration` tab, fill in the `Master username` and `Master password` that will be used in the Script.

- Under `Instance specifications`, choose `db.t3.micro` as the instance class.

-In the `Storage` tab, disable the option `Enable storage autoscaling`.

- In the `Connectivity` tab, select `Do not connect to a compute resource in EC2` and select the previously created VPC under VPC.

- In the `Public accessibility` option, select yes.

- For `VPC security group (firewall)`, choose the security group created earlier for RDS.

- In the `Additional configuration` tab, provide the `Initial database name` which will be needed for the Script.

- Click on `Create database`.

### Execution Model
- In the EC2 menu, search for `Launch Templates` in the left navigation bar.

![MD_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/MD_BARRA.png)

- Access it and click on `Create launch template`.

- Name the launch template and optionally provide a description.

- Under `Application and system images`, select Amazon Linux 2.

- In the `Instance type` tab, choose t2.micro.

- Select an existing key pair or create a new one under `Key pair`.

- In `Network settings`, do not include a subnet in the template, and select the security group created earlier. 

- Under the `Storage` tab, select 8GiB of gp2 storage.

- Add the necessary tags to your instances under `Resource tags`.

- There are two options when using the Script: either use it to create the docker-compose file, or create the docker-compose file separately outside the Script.

<details>
<summary>Use the Script to create the docker-compose file</summary>

- In `Advanced details`, copy the Script from [Here](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/StartWithDockerCompose.sh) and modify the necessary variables marked with <> in the `User data` field.

</details>

<details>
<summary>Criar o docker-compose separadamente</summary>

- In `Advanced details`, copy the Script from [Aqui](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/StartWithoutDockerCompose.sh) and modify the necessary variables marked with <> in the User data field.

- Since the Script won't create the necessary docker-compose file for container initialization, you'll need some additional steps.

- You'll need to create and launch an EC2 instance connected to the previously created EFS. Detailed instructions can be found [Here](https://github.com/zSalocin/ApacheServer_NFS_Script_in_AWS_EC2/blob/main/README.md#criando-uma-instancia-ec2-na-aws).

- Access the instance and navigate to the `/mnt/efs` directory..

- Create a file using the command:

```
vi docker-compose.yml
```

- Copy or type the following content into the file, respecting the formatting.

```
    services:
      wordpress:
        image: wordpress:latest
        volumes:
          - /mnt/efs/wordpress:/var/www/html
        ports:
          - "80:80"
        environment:
          WORDPRESS_DB_HOST: <RDS End point>
          WORDPRESS_DB_USER: <RDS Master Username>
          WORDPRESS_DB_PASSWORD: <Master Password>
          WORDPRESS_DB_NAME: <RDS name, selected in additional settings>
          WORDPRESS_TABLE_CONFIG: wp_
```

- Modify the necessary variables marked with <>.

- Follow the remaining steps until the end of the tutorial, and once the instances are running, delete the instance created for creating the docker-compose file.

</details>

- After finishing the modifications to the StartScript, click on `Create launch template`.

### Target Group
- In the EC2 menu, search for `Target Groups` in the left navigation bar.

![TG_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/TG_BARRA.png)

- Access it and click on `Create target group`.

- In `Choose a target type`, click on `Instances`.

- Name the target group.

- Keep the `Protocol` as `HTTP` and the `Port` as `80`.

- For `VPC`, select the previously created VPC.

- Keep the `Protocol version` as `HTTP1`.

- Click on `Next`.

- On the `Register targets` page, do not select any instances.

- Select `Create target group`.

#Continuar Tradu;'ao

### Load Balancer
- In the EC2 menu, search for `Load Balancer` in the left navigation bar.

![LB_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_BARRA.png)

- Access it and click on `Create Load Balancer`.

- Select `Create` under Application Load Balancer.

- Name the load balancer.

- Choose `Internet-facing` for the `Scheme`.

- Keep `IPv4` for `IP address type`.

- In the `Network mapping` tab, select the VPC network.

- Choose the two previously created public subnets.

![LB_VPC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_VPC.png)

- For `Security group`, select the group created earlier for EC2.

- Under `Listeners and routing`, keep `HTTP:80` and select the previously created target group.

![LB_LISTENER](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/LB_LISTENER.png)

- Click on `Create Load Balancer`.

### Auto Scaling
- In the EC2 menu, search for `Auto Scaling Groups` in the left navigation bar.

![LB_BARRA](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/AU_BARRA.png)

- Access it and click on `Create Auto Scaling Group`.

- Name the Auto Scaling group.

- Select the previously created launch template.

- Click on `Next`.

- Select the previously created VPC.

- Choose the private subnets.

![LB_VPC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/AU_VPC.png)

- Click on `Next`.

- Check the option `Attach to an existing load balancer`.

- Check the option `Choose from your load balancer target groups`.

- Select the previously created target group.

- Click on `Next`.

- Under `Group size`, select:
    - Desired capacity: 2
    - Minimum capacity: 2
    - Maximum capacity: 3

- Click on `Skip to review`.

- Click on `Create Auto Scaling Group`.

### Checking Functionality
- In the EC2 menu, search for `Load Balancers` in the left navigation bar.

- Select the previously created Load Balancer, copy the `DNS Name`, and paste it into a web browser. If the EC2 instances are already running, you should be able to access WordPress.

![WP_LG](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/WP_LG.png)

- Next, configure WordPress.

![WP_CR](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/WP_CR.png)

- From there, you can access and set up WordPress.

- Check the health by accessing `Target Groups`.

- Select the previously created Target Group and verify if the instances are healthy.

![GP_IN](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/GP_IN.png)

- To access the instances and verify them, you need to create an Endpoint. To do this, search for `VPC`.

- In the left menu, select `Endpoints`.

![VPC_END](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/VPC_END.png)

- Click on `Create Endpoint`.

- Name the Endpoint and then select the `Service category` as `EC2 Instance Connect Endpoint`.

- In `VPC`, select the previously created VPC.

- For `Security groups`, choose the group created for the Endpoint.

- Under `Subnet`, select one of the private subnets of the VPC.

- Click on `Create endpoint`.

- Once the Endpoint is created, navigate to the instance you want to connect to.

- Click on `Connect`.

- In the `EC2 Instance Connection` dialog, select `Connect using EC2 Instance Connect endpoint`, and in `EC2 Instance Connect endpoint`, choose the previously created Endpoint. Then click on `Connect`.

<details>
<summary>Test Docker</summary>

- Check the running containers with the command:

```
docker ps
```

![EC2_DC](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_DC.png)

- Check the installation of Docker Compose with the command:

```
docker-compose -v
```

- Check the configuration file with the command:

```
docker-compose ls
```

</details>

<details>
<summary>Test Database</summary>

- Access the running container using the command:

```
docker exec -it <ID_DO_CONTAINER_WORDPRESS> /bin/bash
```

- The `<WORDPRESS_CONTAINER_ID>` can be found using the command:
```
docker ps
```

- Inside the container, execute the following command to update the system:

```
apt-get update
```

- After updating the system, install the MySQL client library:

```
apt-get install default-mysql-client -y
```

- Now, use the following command to enter the MySQL database:

```
mysql -h <ENDPOINT_DO_SEU_RDS> -P 3306 -u admin -p
```

- `<RDS_ENDPOINT>` is the same one used in the script that can be found in the details after creating the Database.

![DC_DB](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/DC_DB.png)

</details>

<details>
<summary>Check Mount</summary>

- Check if the EFS is mounted with the command:

```
df -h
```

![EC2_DF](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_DF.png)

- Check the persistence of the mount. Access the /etc directory with the command:

```
cd /etc
```

- Read the `fstab` file with the command:

```
cat fstab
```

![EC2_FS](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_FS.png)

</details>

<details>
<summary>Check Crontab</summary>

- Check the crontab using the command:

```
crontab -l
```

![EC2_CR](https://github.com/zSalocin/WordPress_With_Docker_AWS/blob/main/Assets/EC2_CR.png)

</details>