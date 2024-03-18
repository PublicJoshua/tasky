provider "google" {
  project     = "ancient-episode-416400"
  region      = "us-east1"
}

resource "google_compute_instance" "mongodb_instance" {
  name         = "mongodb-instance"
  machine_type = "e2-medium"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

 resource "google_compute_address" "static_ip" {
  name   = "static-ip"
  region = "us-east1"
}

  metadata_startup_script = "apt-get update && apt-get install -y mongodb"
}

# Define firewall rule to allow MongoDB traffic
resource "google_compute_firewall" "mongodb_firewall" {
  name    = "mongodb-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Output the external IP of the instance
output "mongodb_instance_ip" {
  value = google_compute_instance.mongodb_instance.network_interface[0].access_config[0].nat_ip

network_interface {
    network = "default"
    access_config {
      // Use the static IP address here
      nat_ip = google_compute_address.static_ip.address
    }
  }
}

}
