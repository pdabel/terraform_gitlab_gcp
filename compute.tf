resource "google_compute_address" "ip_address" {
  name = "gitlab-public-address"
}

data "google_compute_image" "gitlab_image" {
  name = var.gitlab_image
  project = var.project
}

resource "random_password" "gitlab_root_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "gitlab_shared_runner_password" {
  length           = 16
  special          = true
  override_special = "_%@"
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

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = "GITLAB_ROOT_PASSWORD=${random_password.gitlab_root_password.result} GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=${random_password.gitlab_shared_runner_password.result} EXTERNAL_URL=http://${trimsuffix(google_dns_record_set.dns.name, ".")} apt-get -y install gitlab-ee"

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
    create = "30m"
  }

  connection {
    type        = "ssh"
    user        = var.gce_ssh_user
    private_key = file("~/.ssh/id_rsa")
    host        = google_compute_address.ip_address.address
  }

  provisioner "remote-exec" {
    script = "scripts/cloud-init-finished.sh"
  }

}