# Global Variables
env    = "stg"
naming = "TTst"

# VPC Module Variables
vpc-cidr          = "172.0.0.0/16"
availability-zone = ["ap-east-1a", "ap-east-1c"]
pub-sub-count     = 2
pvt-app-count     = 2
pvt-db-count      = 2

# Instance Module Variables
key-name     = "value"
bastion-ami  = "value"
bastion-type = "value"
grafana-ami  = "value"
grafana-type = "value"

# K8S Module Variables
k8s-master-ami       = "value"
k8s-master-type      = "value"
k8s-master-pvt-ip    = "value"
k8s-node-ami         = "value"
k8s-node-type        = "value"
k8s-node-asg-min     = 3
k8s-node-asg-max     = 10
k8s-node-asg-desired = 3

# RDS Module Variables
instance-class = "db.r5.large"

# Route53 Module Variables
zone-name   = "value"
record-name = ""
record-type = "CNAME"
record-ttl  = "300"

# S3 Module Variables
bucket-name = "value"

# VPN Module Variables
my-ip             = "61.85.118.29"
onprem-cidr-block = "192.168.0.84"
