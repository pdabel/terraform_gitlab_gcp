variable "region" {
  default = "europe-west4"
}
variable "project" {}
variable "gitlab_image" {}
variable "dns_zone_name" {}
variable "subnet" {}
variable "source_ips" {
  type = list
}