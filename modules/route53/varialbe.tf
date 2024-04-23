variable "zone-name" {
  type    = string
  default = "final-team1"
}

variable "record-name" {
  type = string

}

variable "record-type" {
  type    = string
  default = "A"
}

variable "record-ttl" {
  type    = string
  default = "300"
}

variable "record-records" {
  type = list(string)
}
