# Global Variables
variable "env" {
  type = string
}

#

variable "vpc-id" {
  type = string
}

variable "availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "k8s-node-sg-id" {
  type = string
}

variable "db-instance-class" {
  type    = string
  default = "db.r5.large"

}

variable "subnet-ids" {
  type = list(string)
}
