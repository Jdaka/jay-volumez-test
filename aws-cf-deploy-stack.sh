#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Parameters
TEMPLATE_URL="https://github.com/Jdaka/jay-volumez-test/blob/main/cross-account-role.yaml"
STACK_NAME="Volumez-Create-Role-Stack"

# Check if REGION is passed as an argument, if not, prompt the user
if [ -z "$1" ]; then
    read -p "Please enter the AWS region (e.g., us-east-1): " REGION
else
    REGION=$1
fi

# Deploy the CloudFormation template
echo "Deploying Volumez CloudFormation stack..."
aws cloudformation create-stack --stack-name $STACK_NAME --template-url $TEMPLATE_URL --capabilities CAPABILITY_NAMED_IAM --region $REGION

# Wait for the stack to be created
echo "Waiting for stack to be created..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION

# Retrieve the role ARN
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query "Stacks[0].Outputs[?OutputKey=='RoleARN'].OutputValue" --output text)

echo "Stack created successfully!"
echo "Role ARN: $ROLE_ARN"
