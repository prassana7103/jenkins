#!/bin/bash

cd /home/ec2-user 

ssh -o StrictHostKeyChecking=no -i ssh.pem ec2-user@43.205.145.115 "
set -x
git clone https://github.com/prassana7103/jenkins.git
cd jenkins 
chmod +x abc.sh
GITLAB_TOKEN=$GITLAB_TOKEN ./abc.sh
"
