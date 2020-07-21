## Info:
This is a simple packer script to create AWS Linux AMI with MySQL server installed

## How to execute?

from packet directory, runr the following command

packer build \
-var SUBNET_ID=`"<Your VPC subnet id>"` \
-var ROOT_PASS=`"<new root password>"` \
-var DB_USER_NAME=`"<new db user>"` \
-var DB_USER_PASS=`"<password for new db user>"` \
packer.json


### example:


packer build \
-var SUBNET_ID="subnet-0fdf9b8fbddba86d45" \
-var ROOT_PASS="Sec#1142pasS" \
-var DB_USER_NAME="db_user" \
-var DB_USER_PASS="dB#pa1234" \
packer.json 



## Whats in the AMI?

- The AMI will install mysql57-community-release 
- Change the default root user password with the given password
- Restrict Root user to localhost only. This means remote access with root user is not allwed
- Create new user with the given username and password
- This new db user can access mysql remotely

