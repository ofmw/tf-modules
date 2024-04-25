#!/bin/bash

# Global Variables
prjt=$(basename $(dirname $(pwd)))
env=$(basename $(pwd))

# Get AWS Regions
echo "Getting AWS Regions..."
aws ec2 describe-regions --query "Regions[].{RegionName: RegionName}" --output text > regions.info
echo "Complete"

# Select Region
echo "======Select Region======"
cat -n "regions.info"
echo "========================="
read -p "Enter Number: " regionNum
region=$(sed -n "${regionNum}p" "regions.info")
sed -i 's/region\s*=\s*"[^"]*"/region = "'"${region}"'"/' terraform.tfvars





# # Get Zone ID
# read -p "Enter Your Zone Name: " zoneName
# echo "Getting Zone IDs..."
# aws route53 list-hosted-zones-by-name --dns-name ${zoneName} > zone.info
# echo "Setting Zone ID..."
# tfNum=$(grep -n "zone-id" terraform.tfvars | cut -d: -f1)
# sed -i 's/zone-id\s*=\s*"[^"]*"/zone-id = "'"${zoneId}"'"/' terraform.tfvars
# echo "Complete"

# # Get Certificates
# aws acm list-certificates --query "CertificateSummaryList[?DomainName == 'adnu04046.shop'].CertificateArn" --output text
