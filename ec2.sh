#!/bin/bash

INSTANCE_NAME="goapi"
AWS_REGION="ap-south-1"  # Replace with your desired region

# Check if an instance with the specified name already exists
existing_instance_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
  --query "Reservations[].Instances[] | [?State.Name!='terminated'].InstanceId" \
  --output text \
  --region "$AWS_REGION"
)
security_group_id=$(aws ec2 create-security-group \
  --group-name MySecurityGroup \
  --description "My Security Group" \
  --region "$AWS_REGION" \
  --output text
)
echo "New security group created with ID: $security_group_id"

# Add inbound rules to the security group (e.g., SSH and HTTP)
echo "Adding inbound rules to the security group..."
aws ec2 authorize-security-group-ingress \
  --group-id "$security_group_id" \
  --protocol tcp \
  --port $PORT \
  --cidr 0.0.0.0/0 \
  --region "$AWS_REGION"


if [ -n "$existing_instance_id" ]; then
  echo "Instance $INSTANCE_NAME already exists with ID: $existing_instance_id"

  instance_state=$(aws ec2 describe-instances \
    --instance-ids "$existing_instance_id" \
    --query "Reservations[].Instances[].State.Name" \
    --output text \
    --region "$AWS_REGION"
  )

  if [ "$instance_state" == "stopped" ]; then
    echo "Starting instance $INSTANCE_NAME..."
    aws ec2 start-instances --instance-ids "$existing_instance_id" --region "$AWS_REGION"
    echo "Instance $INSTANCE_NAME is now running."
  else
    echo "Instance $INSTANCE_NAME is already running."
  fi

else
  existing_terminated_instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
    --query "Reservations[].Instances[] | [?State.Name=='terminated'].InstanceId" \
    --output text \
    --region "$AWS_REGION"
  )

  if [ -n "$existing_terminated_instance_id" ]; then
    echo "Creating a new EC2 instance since the previous instance was terminated."

    new_instance_id=$(aws ec2 run-instances \
      --image-id ami-0da59f1af71ea4ad2 \
      --instance-type t2.micro \
      --key-name ssh \
      --security-group-ids "$security_group_id" \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
      --query "Instances[0].InstanceId" \
      --output text \
      --region "$AWS_REGION"
    )

    echo "New instance $INSTANCE_NAME created with ID: $new_instance_id"
  else
    echo "No existing instance found. Creating a new EC2 instance."

    new_instance_id=$(aws ec2 run-instances \
      --image-id ami-0da59f1af71ea4ad2 \
      --instance-type t2.micro \
      --key-name ssh \
      --security-group-ids "$security_group_id" \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
      --query "Instances[0].InstanceId" \
      --output text \
      --region "$AWS_REGION"
    )

    echo "New instance $INSTANCE_NAME created with ID: $new_instance_id"
  fi
fi
