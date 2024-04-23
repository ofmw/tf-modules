#!/bin/bash

# Get AWS Regions
echo "Getting AWS Regions..."
aws ec2 describe-regions --query "Regions[].{RegionName: RegionName}" --output text > regions.info
echo "Complete"