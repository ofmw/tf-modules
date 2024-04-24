#!/bin/bash

# Global Variables
prjt=$(basename $(dirname $(pwd)))
env=$(basename $(pwd))

# Get AWS Regions
echo "Getting AWS Regions..."
aws ec2 describe-regions --query "Regions[].{RegionName: RegionName}" --output text > regions.info
echo "Complete"

# Get Zone ID
read -p "Enter Your Zone Name: " zoneName
echo "Getting Zone IDs..."
aws route53 list-hosted-zones-by-name --dns-name ${zoneName} > zone.info
echo "Setting Zone ID..."
tfNum=$(grep -n "zone-id" terraform.tfvars | cut -d: -f1)
sed -i 's/zone-id\s*=\s*"[^"]*"/zone-id = "'"${zoneId}"'"/' terraform.tfvars
echo "Complete"