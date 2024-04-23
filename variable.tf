variable "vpc-cidr" {
  type    = string
  default = "172.0.0.0/16"
}

variable "availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "pub-num" {
  type = number
}

variable "pvt-app-num" {
  type = number
}

variable "pvt-db-num" {
  type = number
}

variable "bucket-name" {
  type = string
}

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

variable "instance-class" {
  type = string
}

variable "onprem-cidr-block" {
  type = string
}
variable "my-ip" {
  type = string
}
