data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone_name
}

resource "google_dns_record_set" "dns" {
  name = "gitlab.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = [google_compute_address.ip_address.address]
}