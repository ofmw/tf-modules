#!/bin/bash

# Global Variables
env=$(basename $(pwd))
prjt=$(basename $(dirname $(pwd)))

# Get AWS Regions
echo "Getting AWS Regions..."
aws ec2 describe-regions --query "Regions[].{RegionName: RegionName}" --output text > regions.info
echo "Get Completed"

# Select Region
echo "========SELECT REGION========="
cat -n "regions.info"
echo "=============================="
read -p "Enter Number: " inputAns
region=$(sed -n "${inputAns}p" "regions.info")
sed -i 's/region\s*=\s*"[^"]*"/region = "'"${region}"'"/' terraform.tfvars
echo "Set Region To ${region}"
echo "Getting ${region} AZs..."
aws ec2 describe-availability-zones --region $region --query "AvailabilityZones[].{ZoneName: ZoneName}" --output text  > azs.info
echo "Get Completed"
echo "==========SELECT AZS=========="
cat -n "azs.info"
echo "=============================="
read -p "[AZ-1]Enter Number: " azNum1
read -p "[AZ-2]Enter Number: " azNum2
az1=$(sed -n "${azNum1}p" "azs.info")
az2=$(sed -n "${azNum2}p" "azs.info")
sed -i 's/availability-zone\s*=\s*\["[^"]*",\s*"[^"]*"\]/availability-zone = ["'"${az1}"'", "'"${az2}"'"]/' terraform.tfvars
echo "Set AZ-1 ${az1}"
echo "Set AZ-2 ${az2}"

# Set Environment & Naming
echo "Setting Environment & Naming..."
sed -i 's/env\s*=\s*"[^"]*"/env = "'"${env}"'"/' terraform.tfvars
sed -i 's/env\s*=\s*"[^"]*"/env = "'"${prjt}"'"/' terraform.tfvars
echo "Set Enviroment To ${env}"
echo "Set Naming To ${prjt}"

# Set VPC Module Variables
vpcCidr="172.0.0.0/16"
read -p "Enter VPC CIDR Blocks[Default:172.0.0.0/16]: " inputCidr
if [ -n "${inputCidr}" ];then
	vpcCidr="${inputCidr}"
fi
read -p "Enter Private Subnet Tier[1~3]: " inputTier
tier=$(($inputTier))
tierUsageStatusList=()
for ((i=1; i<=3; i++))
do
    if [ $tier -gt 0 ];then
        tierUsageStatusList+=(1)
        tier=$(($tier - 1))
    else
        tierUsageStatusList+=(0)
    fi
done
sed -i 's/tier-usage-status-list\s*=\s*\[[^]]*\]/tier-usage-status-list = ['"${tierUsageStatusList[0]}"', '"${tierUsageStatusList[1]}"', '"${tierUsageStatusList[2]}"']/' terraform.tfvars
if [ $((inputTier)) -eq 0 ];then
    echo "Set Subnet Only Public"
else
    echo "Set Private Subnet ${inputTier}Tier"
fi

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
        echo "Getting Instance Type From ${region}..."
        aws ec2 describe-instance-type-offerings --location-type "availability-zone" --region $region --query "InstanceTypeOfferings[?starts_with(InstanceType, 't3')].[InstanceType]" --output text | sort | uniq > instanceType.info
        echo "Get Completed"
        while :
        do
            read -p "Enter Instance Name: " instanceName
            instanceNameList+=($instanceName)
            echo "=======SELECT AMI TYPE========"
            echo "    1.Default    2.Custom"
            echo "=============================="
            read -p "Enter Number: " inputAns
            while : 
            do
                if [ "$inputAns" != "1" ] && [ "$inputAns" != "2" ];then
                    read -p "Please Enter '1' or '2': " inputAns
                else
                    break
                fi
            done
            if [ $inputAns == "1" ];then
                echo "===========AMI LIST==========="
                echo "1.AMZN2 2.Ubuntu-20.04 3.RHEL9"
                echo "=============================="
                read -p "Enter Number: " inputAns
                amiName=($(sed -n "${inputAns}p" "amiName.data"))
                echo "Setting AMI..."
                instanceAmiList+=($(aws ec2 describe-images \
                --owners amazon \
                --filters "Name=name,Values=$amiName" "Name=state,Values=available" \
                --query "reverse(sort_by(Images, &Name))[:1].ImageId" \
                --region "$region" \
                --output text))
                echo "Set Completed"
            fi
            echo "=====SELECT INSTANCE TYPE====="
            cat -n "instanceType.info"
            echo "=============================="
            read -p "Enter Number: " inputAns
            instanceTypeList+=($(sed -n "${inputAns}p" "instanceType.info"))
            read -p "Enter Key Pair Name: " inputAns
            instanceKeyNameList+=($inputAns)
            read -p "Allocation of Public IP[y/n]: " inputAns
            while : 
            do
                if [ $inputAns != "y" ] && [ $inputAns != "n" ];then
                    read -p "Please Enter 'y' or 'n': " inputAns
                else
                    break
                fi
            done
            if [ $inputAns == "y" ];then
                instancePubIpUsageList+=(true)
            else
                instancePubIpUsageList+=(false)
            fi
            length=${#instanceNameList[@]}
            echo "========INSTANCE INFO========="
            echo "Name : ${instanceNameList[length-1]}"
            echo "AMI  : ${instanceAmiList[length-1]}"
            echo "Type : ${instanceTypeList[length-1]}"
            echo "Key  : ${instanceKeyNameList[length-1]}"
            echo "PubIp: ${instancePubIpUsageList[length-1]}"
            echo "=============================="
            read -p "Instance Info Above Correct?[y/n]: " inputAns
            while : 
            do
                if [ $inputAns != "y" ] && [ $inputAns != "n" ];then
                    read -p "Please Enter 'y' or 'n': " inputAns
                elif [ $inputAns == "n" ];then
                    unset 'instanceNameList[length-1]'
                    unset 'instanceAmiList[length-1]'
                    unset 'instanceTypeList[length-1]'
                    unset 'instanceKeyNameList[length-1]'
                    unset 'instancePubIpUsageList[length-1]'
                    break
                else
                    break
                fi
            done
            if [ $inputAns == "n" ];then

                break
            fi
            read -p "Add Instance Continue?[y/n]: " inputAns
            while : 
            do
                if [ $inputAns != "y" ] && [ $inputAns != "n" ];then
                    read -p "Please Enter 'y' or 'n': " inputAns
                else
                    break
                fi
            done
            if [ $inputAns == "n" ];then
                break
            fi
        done
        instanceCount=${#instanceNameList[@]}
        sed -i 's/instance-name-list\s*=\s*\[[^]]*\]/instance-name-list = ['"$(printf '"%s", ' "${instanceNameList[@]}")"']/g' terraform.tfvars
        sed -i 's/instance-ami-list\s*=\s*\[[^]]*\]/instance-ami-list = ['"$(printf '"%s", ' "${instanceAmiList[@]}")"']/g' terraform.tfvars
        sed -i 's/instance-type-list\s*=\s*\[[^]]*\]/instance-type-list = ['"$(printf '"%s", ' "${instanceTypeList[@]}")"']/g' terraform.tfvars
        sed -i 's/instance-key-name-list\s*=\s*\[[^]]*\]/instance-key-name-list = ['"$(printf '"%s", ' "${instanceKeyNameList[@]}")"']/g' terraform.tfvars
        sed -i 's/instance-pub-ip-usage-list\s*=\s*\[[^]]*\]/instance-pub-ip-usage-list = ['"$(printf '"%s", ' "${instancePubIpUsageList[@]}")"']/g' terraform.tfvars
        sed -i 's/instance-count\s*=\s*[^"]*/instance-count = '${instanceCount}'/' terraform.tfvars
        break
    else
        bool=false
        break
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
# aws acm list-certificates --query "CertificateSummaryList[?DomainName == 'adnu04046.shop'].CertificateArn" --output text
