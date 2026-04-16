#!/bin/bash

set -e  # Stop on error (equivalent to $ErrorActionPreference = "Stop")

# --- 1. CONFIGURATION ---
PROJECT_NAME="project-stack"  #match the name in your ECR repository without the "-api" suffix
AWS_ACCOUNT_ID="874708625880" # Your 12-digit AWS Account ID, should be on the top right conner, 
AWS_REGION="us-east-1"  # The AWS region where your ECR repository is located, e.g. us-east-1, us-west-2, etc.

# --- 2. DERIVED VARIABLES ---
REPO_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_TAG="$REPO_URL/$PROJECT_NAME-api:latest"

# --- 3. THE EXECUTION ---

# Build the image locally
echo "Building Docker image..."
docker build -t "$PROJECT_NAME-api" .

# Login to AWS ECR
echo "Logging into AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL

# Tag the image for the remote repository
echo "Tagging image..."
docker tag "$PROJECT_NAME-api:latest" $IMAGE_TAG

# Push to the cloud
echo "Pushing to AWS ECR..."
docker push $IMAGE_TAG

echo "Success! Image is now in the cloud."

