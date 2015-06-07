resource "google_compute_network" "coreos" {
  name = "coreos"
  ipv4_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "external" {
  name = "external"
  network = "${google_compute_network.coreos.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }

  allow {
    protocol = "udp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "internal" {
  name = "internal"
  network = "${google_compute_network.coreos.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = ["${google_compute_network.coreos.ipv4_range}"]
}

resource "google_compute_instance" "coreos-leader" {
  count = 3
  name = "coreos-leader-${count.index}"
  description = "Leader instance of cluster"
  machine_type = "${var.gce_machine_type}"
  zone = "${var.gce_zone}"
  tags = ["coreos", "beta", "leader", "etcd", "consul", "http-server"]

  # boot disk
  disk {
    image = "${var.gce_coreos_disk_image}"
  }

  network_interface {
    network = "${google_compute_network.coreos.name}"
    access_config {
      // ephemeral IP
    }
  }

  metadata {
    user-data = "${file("cloud-config-leader.yaml")}"
  }
}

output "leader_name" {
  value = "${join(", ", google_compute_instance.coreos-leader.*.name)}"
}

output "leader_private_address" {
  value = "${join(", ", google_compute_instance.coreos-leader.*.network_interface.0.address)}"
}

output "leader_public_address" {
  value = "${join(", ", google_compute_instance.coreos-leader.*.network_interface.0.access_config.0.nat_ip)}"
}
