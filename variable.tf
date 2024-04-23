# Global Variables
variable "env" { # 환경명 ex)prd, stg, dev...
  type = string
}

variable "naming" {
  type = string
}

##

# VPC Module Variables
variable "vpc-cidr" {
  type    = string
  default = "172.0.0.0/16"
}

variable "availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "pub-sub-count" {
  type = number
}

variable "pvt-app-count" {
  type = number
}

variable "pvt-db-count" {
  type = number
}

##

# Instance Module Variables
variable "key-name" {
  type = string
}

variable "bastion-ami" {
  type = string
}

variable "bastion-type" {
  type = string
}

variable "grafana-ami" {
  type = string
}

variable "grafana-type" {
  type = string
}

##

# K8S Module Variables
variable "k8s-master-ami" {
  type = string
}

variable "k8s-master-type" {
  type = string
}

variable "k8s-master-pvt-ip" {
  type = string
}

variable "k8s-node-ami" {
  type = string
}

variable "k8s-node-type" {
  type = string
}

variable "k8s-node-asg-min" {
  type = number
}

variable "k8s-node-asg-max" {
  type = number
}

variable "k8s-node-asg-desired" {
  type = number
}

##

# RDS Module Variables
variable "instance-class" {
  type = string
}

##

# Route53 Module Variables
variable "zone-name" {
  type = string
}

variable "record-name" {
  type = string
}

variable "record-type" {
  type = string
}

variable "record-ttl" {
  type = string
}


# S3 Module Variables
variable "bucket-name" {
  type = string
}

##

# VPN Module Variables
variable "my-ip" {
  type = string
}

variable "onprem-cidr-block" {
  type = string
}
