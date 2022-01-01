output "gitlab_public_ip" {
  value = google_compute_address.ip_address.address
}

output "gitlab_host_name" {
  value = google_dns_record_set.dns.name
}

output "gitlab_url" {
  value = "http://${trimsuffix(google_dns_record_set.dns.name, ".")}"
}

output "gitlab_internal_url" {
  value = "http://${google_compute_instance.gitlab_instance.network_interface[0].network_ip}"
}

output "gitlab_ssh_access" {
  value = "ubuntu@${google_dns_record_set.dns.name}"
}

output "gitlab_root_password" {
  value = random_password.gitlab_root_password.result
}

output "gitlab_shared_runner_password" {
  value = random_password.gitlab_shared_runner_password.result
}