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
