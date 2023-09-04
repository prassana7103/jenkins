#!/bin/bash

cd /home/ec2-user 

ssh -o StrictHostKeyChecking=no -i ssh.pem ec2-user@13.127.23.202 "
set -x
sudo rm -rf actions-runner 
git clone https://github.com/prassana7103/jenkins.git
cd jenkins 
chmod +x abc.sh
GITLAB_TOKEN=$GITLAB_TOKEN ./abc.sh
"
