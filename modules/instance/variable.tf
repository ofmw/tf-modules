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

variable "my-ip" {
  type = string
}
