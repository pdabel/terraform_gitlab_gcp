resource "google_compute_network" "vpc_network" {
  name = "gitlab"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gitlab"
  ip_cidr_range = var.subnet
  region        = var.region
  network       = google_compute_network.vpc_network.id
  private_ip_google_access  = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "gitlab" {
  name    = "gitlab-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  source_ranges = [ "86.45.159.64/32" ]
  target_tags = ["gitlab"]
}