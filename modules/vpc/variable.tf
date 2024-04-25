# Global Variables
variable "env" {
  type = string
}

#

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
