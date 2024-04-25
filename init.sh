#!/bin/bash

# # Global Variables
# env=$(basename $(pwd))
# prjt=$(basename $(dirname $(pwd)))

# # Get AWS Regions
# echo "Getting AWS Regions..."
# aws ec2 describe-regions --query "Regions[].{RegionName: RegionName}" --output text > regions.info
# echo "Get Regions Completed"

# # Select Region
# echo "======Select Region======"
# cat -n "regions.info"
# echo "========================="
# read -p "Enter Number: " inputAns
# region=$(sed -n "${inputAns}p" "regions.info")
# sed -i 's/region\s*=\s*"[^"]*"/region = "'"${region}"'"/' terraform.tfvars
# echo "Set Region To ${region}"
# echo "Getting ${region} AZs..."
# aws ec2 describe-availability-zones --region $region --query "AvailabilityZones[].{ZoneName: ZoneName}" --output text  > azs.info
# echo "========Select AZs======="
# cat -n "azs.info"
# echo "========================="
# read -p "[AZ-1]Enter Number: " azNum1
# read -p "[AZ-2]Enter Number: " azNum2
# az1=$(sed -n "${azNum1}p" "azs.info")
# az2=$(sed -n "${azNum2}p" "azs.info")
# sed -i 's/availability-zone\s*=\s*\["[^"]*",\s*"[^"]*"\]/availability-zone = ["'"${az1}"'", "'"${az2}"'"]/' terraform.tfvars
# echo "Set AZ-1 ${az1}"
# echo "Set AZ-2 ${az2}"

# # Set Environment & Naming
# echo "Setting Environment & Naming..."
# sed -i 's/env\s*=\s*"[^"]*"/env = "'"${env}"'"/' terraform.tfvars
# sed -i 's/env\s*=\s*"[^"]*"/env = "'"${prjt}"'"/' terraform.tfvars
# echo "Set Enviroment To ${env}"
# echo "Set Naming To ${prjt}"

# # Set VPC Module Variables
# vpcCidr="172.0.0.0/16"
# read -p "Enter VPC CIDR Blocks[Default:172.0.0.0/16]: " inputCidr
# if [ -n "${inputCidr}" ];then
# 	vpcCidr="${inputCidr}"
# fi
# read -p "Enter Private Subnet Tier[1~3]: " inputTier
# tier=$(($inputTier))
# tierUsageStatusList=()
# for ((i=1; i<=3; i++))
# do
#     if [ $tier -gt 0 ];then
#         tierUsageStatusList+=(1)
#         tier=$(($tier - 1))
#     else
#         tierUsageStatusList+=(0)
#     fi
# done
# sed -i 's/tier-usage-status-list\s*=\s*\[[^]]*\]/tier-usage-status-list = ['"${tierUsageStatusList[0]}"', '"${tierUsageStatusList[1]}"', '"${tierUsageStatusList[2]}"']/' terraform.tfvars
# if [ $((inputTier)) -eq 0 ];then
#     echo "Set Subnet Only Public"
# else
#     echo "Set Private Subnet ${inputTier}Tier"
# fi

# Set Instance Module Variables
read -p "Add an EC2 Instance?[y/n]: " inputAns
while :
do
    if [ "$inputAns" != "y" ] && [ "$inputAns" != "n" ];then
        read -p "Please Enter 'y' or 'n': " inputAns
    elif [ "$inputAns" == "y" ];then
        bool=true
        instanceNameList=()
        instanceAmiList=()
        instanceTypeList=()
        instanceKeyNameList=()
        instancePubIpUsageList=()
        break
    else
        bool=false
        break
    fi
done
while :
do
    read -p "Enter Instance Name: " instanceName
    instanceNameList+=($instanceName)
    echo "======Instance Ami======="
    echo "  1.Default   2.Custom"
    echo "========================="
    read -p "Enter Number: " inputAns
    if [ "$inputAns" != "1" ] && [ "$inputAns" != "2" ];then

    fi
done


# if [ "$bool" = true ]; then
#     sed -i 's/instance-count\s*=\s*[^"]*/instance-count = '${instanceCount}'/' terraform.tfvars
# fi






# # Get Zone ID
# read -p "Enter Your Zone Name: " zoneName
# echo "Getting Zone IDs..."
# aws route53 list-hosted-zones-by-name --dns-name ${zoneName} > zone.info
# echo "Setting Zone ID..."
# tfNum=$(grep -n "zone-id" terraform.tfvars | cut -d: -f1)
# sed -i 's/zone-id\s*=\s*"[^"]*"/zone-id = "'"${zoneId}"'"/' terraform.tfvars
# echo "Complete"

# # Get Certificates
# aws acm list-certificates --query "CertificateSummaryList[?DomainName == 'ofmw.site'].CertificateArn" --output text
