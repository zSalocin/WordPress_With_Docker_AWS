#!/bin/bash

# update the opearational system
sudo yum update -y

# Install Docker
sudo yum install docker -y

# Start Docker
sudo systemctl start docker

# Enable Docker service
sudo systemctl enable docker

# Add the current user to the 'docker' group
sudo usermod -aG docker ec2-user

# Configure Docker to start on system boot
sudo chkconfig docker on

# Install the utility nfs-utils
sudo yum install nfs-utils -y

# Create the 'efs' directory inside the 'mnt' directory
sudo mkdir /mnt/efs/

# Grant read, write, and execute permissions for all users to the 'efs' directory
sudo chmod +rwx /mnt/efs/

# Mount the Amazon EFS filesystem
sudo mount -t efs <DNS_NAME_DO_EFS>:/ /mnt/efs

# Add an entry to /etc/fstab for persistent mount
echo "<DNS_NAME_DO_EFS>:/ /mnt/efs nfs4 defaults 0 0" >> /etc/fstab

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make the Docker Compose binary executable
sudo chmod +x /usr/local/bin/docker-compose

# Move Docker Compose binary to a directory in the system's PATH
sudo mv /usr/local/bin/docker-compose /bin/docker-compose