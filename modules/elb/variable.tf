variable "vpc-id" {
  type = string
}

variable "pub-sub-id" {
  type = list(string)
}

variable "grafana-server-id" {
  type = string
}

variable "k8s-master-id" {
  type = string
}
