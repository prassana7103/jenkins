#!/bin/bash

set -x
sudo yum install git -y 
ls
sudo rm -rf actions-runner 
mkdir actions-runner && cd actions-runner 
sudo yum install perl-Digest-SHA -y 
sudo yum install libicu -y 
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true 
curl -o actions-runner-linux-x64-2.308.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz 
tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz
export TOKEN=$(curl -s -L -X POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer $GITLAB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/prassana7103/Go-API/actions/runners/registration-token" | jq -r .token)
export URL="https://github.com/prassana7103/Go-API"
./config.sh --url "$URL" --token "$TOKEN"
nohup ./run.sh &
