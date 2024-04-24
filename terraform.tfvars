# Global Variables
env    = "stg"
naming = "TTst"

# VPC Module Variables
vpc-cidr               = "172.0.0.0/16"
availability-zone      = ["us-east-1a", "us-east-1c"]
tier-usage-status-list = [1, 1, 0]

# Instance Module Variables
instance-count             = 2
instance-ami-list          = ["ami-0a699202e5027c10d", "ami-0e2e7790c9fde3da2"]
instance-type-list         = ["t3.micro", "t3.small"]
instance-key-name-list     = ["cloud-ec2", "cloud-ec2"]
instance-pub-ip-usage-list = [true, false]
instance-name-list         = ["bastion", "monitor"]

# K8S Module Variables
k8s-key-name         = "cloud-ec2"
k8s-master-ami       = "ami-07bdaabc965ddd717"
k8s-master-type      = "t3.medium"
k8s-node-ami         = "ami-0952a1bbbbe7ddef5"
k8s-node-type        = "t3.small"
k8s-node-asg-min     = 3
k8s-node-asg-max     = 10
k8s-node-asg-desired = 3

# RDS Module Variables
instance-class = "db.r5.large"

# Route53 Module Variables
zone-id = "Z08062961F3KIWZPT1TQZ"
record-name = "www"
record-type = "CNAME"
record-ttl  = "300"

# S3 Module Variables
bucket-name = "hangaramit01-bucket-test"

# VPN Module Variables
my-ip             = "61.85.118.29"
onprem-cidr-block = "192.168.0.0/24"
