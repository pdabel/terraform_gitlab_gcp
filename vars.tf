variable "region" {
  default = "europe-west4"
}
variable "project" {}
variable "gitlab_image" {}
variable "gitlab_runner_image" {}
variable "dns_zone_name" {}
variable "subnet" {}
variable "source_ips" {
  type = list
}
variable "gce_ssh_user" {}
variable "gce_ssh_pub_key_file" {}