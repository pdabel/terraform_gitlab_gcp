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

resource "google_compute_firewall" "gitlab_external_access" {
  name    = "gitlab-external-access-firewall"
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

  source_ranges = var.source_ips
  target_tags = ["gitlab"]
}

resource "google_compute_firewall" "runner_external_access" {
  name    = "runner-external-access-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  source_ranges = var.source_ips
  target_tags = ["runners"]
}

resource "google_compute_firewall" "gitlab_runner_access" {
  name    = "gitlab-runner-access-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  source_ranges = [var.subnet]
  target_tags = ["gitlab"]
}