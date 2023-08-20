#!/bin/bash

INSTANCE_NAME="goapi"

# Check if an instance with the specified name already exists
existing_instance_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text
)

if [ -n "$existing_instance_id" ]; then
  echo "Instance $INSTANCE_NAME already exists with ID: $existing_instance_id"
else
  # Create a new EC2 instance
  new_instance_id=$(aws ec2 run-instances \
    --image-id ami-0da59f1af71ea4ad2 \
    --instance-type t2.micro \
    --key-name ssh \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query "Instances[0].InstanceId" \
    --output text
  )
  
  echo "Instance $INSTANCE_NAME created with ID: $new_instance_id"
fi
