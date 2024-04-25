# Global Variables
variable "env" {
  type = string
}

#

variable "vpc-id" {
  type = string
}

variable "pvt-sub-ids" {
  type = list(string)
}

variable "pvt-sub-cidr-blocks" {
  type = list(string)
}

variable "k8s-key-name" {
  type = string
}

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
  type    = string
  default = "t3.small"
}

variable "k8s-service-tg-80" {
  type = string
}

variable "k8s-node-asg-min" {
  type    = number
  default = 3
}

variable "k8s-node-asg-max" {
  type    = number
  default = 10
}

variable "k8s-node-asg-desired" {
  type    = number
  default = 3
}
