#cloud-config
package_update: true
package_upgrade: true
runcmd:
# update the opearational system
- yum update -y
# Install Docker
- yum install docker -y
# Start Docker
- systemctl start docker
# Enable Docker service
- systemctl enable docker
# Add the current user to the 'docker' group
- usermod -aG docker ec2-user
# Configure Docker to start on system boot
- chkconfig docker on
# Install Docker Compose
- curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Make the Docker Compose binary executable
- chmod +x /usr/local/bin/docker-compose
# Move Docker Compose binary to a directory in the system's PATH
- mv /usr/local/bin/docker-compose /bin/docker-compose
# Install the utility nfs-utils
- yum install -y amazon-efs-utils
# Install NFS utilities for Amazon EFS
- yum install -y nfs-utils
# Configure EFS, replace <DNS_NAME_DO_EFS> with your EFS
- file_system_id_1=<DNS_NAME_DO_EFS>
# Set the mount point
- efs_mount_point_1=/mnt/efs
# Create a directory for EFS mount point
- mkdir -p "${efs_mount_point_1}"
# Check if "mount.efs" exists and configure /etc/fstab accordingly
- test -f "/sbin/mount.efs" && printf "\n${file_system_id_1}:/ ${efs_mount_point_1} efs tls,_netdev\n" >> /etc/fstab || printf "\n${file_system_id_1}.efs.us-east-1.amazonaws.com:/ ${efs_mount_point_1} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0\n" >> /etc/fstab
# Configure "efs-utils.conf" for some systems
- test -f "/sbin/mount.efs" && grep -ozP 'client-info]\nsource' '/etc/amazon/efs/efs-utils.conf'; if [[ $? == 1 ]]; then printf "\n[client-info]\nsource=liw\n" >> /etc/amazon/efs/efs-utils.conf; fi;
# Attempt to mount EFS with retries
- retryCnt=15; waitTime=30; while true; do mount -a -t efs,nfs4 defaults; if [ $? = 0 ] || [ $retryCnt -lt 1 ]; then echo File system mounted successfully; break; fi; echo File system not available, retrying to mount.; ((retryCnt--)); sleep $waitTime; done;