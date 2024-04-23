variable "vpc-id" {
  type = string
}

variable "pub-sub-cidr" {
  type = list(string)
}

variable "pvt-sub-app-cidr" {
  type = list(string)
}

variable "key-name" {
  type = string
}

variable "bastion-ami" {
  type    = string
  default = "ami-0a699202e5027c10d"
}

variable "bastion-type" {
  type    = string
  default = "t3.micro"
}

variable "grafana-depends-on" {
  type = list(string)
  #aws_lb_target_group.k8s-grafana-tg-3000
}

variable "grafana-ami" {
  type = string
}

variable "grafana-type" {
  type = string
}

variable "k8s-master-depends-on" {
  type = list(string)
  #aws_lb_target_group.k8s-prometheus-tg-9090
}

variable "k8s-master-ami" {
  type = string
}

variable "k8s-master-type" {
  type = string
}

variable "k8s-master-pvt-ip" {
  type    = string
  default = "172.0.20.10"
}

variable "k8s-node-ami" {
  type = string

}

variable "k8s-node-type" {
  type    = string
  default = "t3.small"
}

variable "k8s-service-tg-80" {
  type = list(string)
  #ouput
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

variable "my-ip" {
  type = string
}
