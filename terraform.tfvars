# Global Variables
region = "us-east-1"
env    = "prd"
naming = "TTst"

# VPC Module Variables
vpc-cidr               = "172.0.0.0/16"
availability-zone      = ["us-east-1a", "us-east-1c"]
tier-usage-status-list = [1, 1, 0]

# Instance Module Variables
instance-name-list         = ["bastion", "traffic", "monitor", "monitor-monitor", "rds-bastion"]
instance-ami-list          = ["ami-0a699202e5027c10d", "ami-05c537410f657c6ce", "ami-0eb0c5a0e831ebf48", "ami-038009ed6c764aad8", "ami-0a699202e5027c10d"]
instance-type-list         = ["t3.micro", "t3.small", "t3.small", "t3.small", "t3.micro"]
instance-key-name-list     = ["cloud-ec2", "cloud-ec2", "cloud-ec2", "cloud-ec2", "cloud-ec2"]
instance-pub-ip-usage-list = [true, true, false, false, false]
instance-count             = 5

# K8S Module Variables
k8s-key-name         = "cloud-ec2"
k8s-master-ami       = "ami-07bdaabc965ddd717"
k8s-master-type      = "t3.medium"
k8s-node-ami         = "ami-0952a1bbbbe7ddef5"
k8s-node-type        = "t3.small"
k8s-node-asg-desired = 3
k8s-node-asg-min     = 3
k8s-node-asg-max     = 20

# RDS Module Variables
instance-class = "db.r5.large"

# Route53 Module Variables
zone-id     = "Z06843161NL0E51475IU6"
record-name = "www"
record-type = "CNAME"
record-ttl  = "300"

# S3 Module Variables
bucket-name = "hangaramit-s3-bucket"

# VPN Module Variables
my-ip             = "61.85.118.29"
onprem-cidr-block = "192.168.0.0/24"
