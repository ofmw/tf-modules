variable "vpc-id" {
  type = string
}

variable "availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "db-subnet-group-name" {
  type = string
}

variable "k8s-node-sg" {
  type = list(string)
}

variable "db-instance-class" {
  type    = string
  default = "db.r5.large"

}
