output "gitlab_public_ip" {
  value = google_compute_address.ip_address.address
}

output "gitlab_host_name" {
  value = google_dns_record_set.dns.name
}

output "gitlab_url" {
  value = "http://${trimsuffix(google_dns_record_set.dns.name, ".")}"
}