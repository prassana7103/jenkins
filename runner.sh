#!/bin/bash

cd /home/ec2-user && 
ls &&
ssh -o StrictHostKeyChecking=no -i ssh.pem ec2-user@65.1.136.208 "sudo yum install git -y && 
ls &&
mkdir actions-runner && cd actions-runner &&
sudo yum install perl-Digest-SHA -y &&
sudo yum install libicu -y &&
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true &&
curl -o actions-runner-linux-x64-2.308.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz && 
echo "9f994158d49c5af39f57a65bf1438cbae4968aec1e4fec132dd7992ad57c74fa  actions-runner-linux-x64-2.308.0.tar.gz\" > checksum.txt
sudo shasum -a 256 -c checksum.txt
tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz &&
response=$(curl -L \
 -X POST \
 -H \"Accept: application/vnd.github.v3+json\" \
 -H \"Authorization: Bearer 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" \
 -H "X-GitHub-Api-Version: 2022-11-28" \
 "https://api.github.com/repos/prassana7103/Go-API/actions/runners/registration-token")

token=$(echo "$response" | jq -r '.token')
echo "Runner Token: $token"
./config.sh --url https://github.com/prassana7103/Go-API --token $token &&
./run.sh &"
