# Global Variables
variable "env" {
  type = string
}

variable "naming" {
  type = string
}

# Instance Variables

variable "instance-count" {
  type = number
}

variable "instance-ami-list" {
  type = list(string)
}

variable "instance-type-list" {
  type = list(string)
}

variable "instance-sub-id-list" {
  type = list(string)
}

variable "instance-key-name-list" {
  type = list(string)
}

variable "instance-pub-ip-usage-list" {
  type = list(bool)
}

variable "instance-name-list" {
  type = list(string)
}

variable "vpc-id" {
  type = string
}

variable "availability-zone" {
  type = list(string)
}

variable "my-ip" {
  type = string
}
