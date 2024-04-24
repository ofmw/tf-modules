# Global Variables
variable "env" { # ex)prd, stg, dev...
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

variable "tier-usage-status-list" {
  type = list(number)
}

##

# Instance Module Variables

variable "instance-count" {
  type = number
}

variable "instance-ami-list" {
  type = list(string)
}

variable "instance-type-list" {
  type = list(string)
}

variable "instance-key-name-list" {
  type = list(string)
}

variable "instance-pub-ip-usage-list" {
  type = list(bool)
}

variable "instance-name-list" {
  type = list(string)
}

##

# K8S Module Variables
variable "k8s-master-ami" {
  type = string
}

variable "k8s-master-type" {
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

variable "k8s-key-name" {
  type = string
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
