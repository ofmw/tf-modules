variable "vpc-cidr" {
  type    = string
  default = "172.0.0.0/16"
}

variable "availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "pub-sub-cidr" {
  type    = list(string)
  default = ["172.0.10.0/25", "172.0.10.128/25"]
}

variable "pvt-sub-app-cidr" {
  type    = list(string)
  default = ["172.0.20.0/25", "172.0.20.128/25"]
}

variable "pvt-sub-db-cidr" {
  type    = list(string)
  default = ["172.0.30.0/25", "172.0.30.128/25"]
}
