# Global Variables
variable "env" {
  type = string
}

#

variable "vpc-id" {
  type = string
}

variable "pub-sub-ids" {
  type = list(string)
}

variable "grafana-server-id" {
  type = string
}

variable "grafana-grafana-server-id" {
  type = string
}

variable "k8s-master-id" {
  type = string
}
