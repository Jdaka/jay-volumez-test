#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Parameters
TEMPLATE_URL="https://raw.githubusercontent.com/Jdaka/jay-volumez-test/main/cross-account-role.yaml"
STACK_NAME="Volumez-Create-Role-Stack"

# Use provided region or prompt the user
REGION="${1:-}"
if [ -z "$REGION" ]; then
    echo "No region provided. Exiting."
    exit 1
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
