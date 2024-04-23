variable "vpc-id" {
  type = string
}

variable "pub-rtb-id" {
  type = string
}


variable "my-ip" {
  type = string
}

variable "onprem-cidr-block" {
  type    = string
  default = "192.168.0.0/24"
}
