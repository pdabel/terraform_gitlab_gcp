resource "google_compute_address" "ip_address" {
  name = "gitlab-public-address"
}

data "google_compute_image" "gitlab_image" {
  name = var.gitlab_image
  project = var.project
}

resource "google_compute_instance" "gitlab_instance" {
  name         = "gitlab"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.gitlab_image.self_link
    }
  }

  metadata_startup_script = "EXTERNAL_URL=http://${trimsuffix(google_dns_record_set.dns.name, ".")} apt-get -y install gitlab-ee"

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  tags = ["gitlab"]

  depends_on = [
    google_dns_record_set.dns
  ]

  timeouts {
    create = "15m"
  }
}