resource "google_compute_network" "core" {
  name = "core"
  ipv4_range = "10.0.0.0/16"
}

resource "google_compute_address" "core" {
  name = "public-ip"
}

resource "google_compute_firewall" "external" {
  name = "external"
  network = "${google_compute_network.core.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "80", "8080", "8500"]
  }

  allow {
    protocol = "udp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "internal" {
  name = "internal"
  network = "${google_compute_network.core.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = ["${google_compute_network.core.ipv4_range}"]
}

resource "google_compute_instance" "core-leader" {
  count = "${var.gce_leader_instance_count}"
  name = "core-leader-${count.index}"
  description = "Leader instance of cluster"
  machine_type = "${var.gce_machine_type}"
  zone = "${var.gce_zone}"
  tags = ["coreos", "stable", "leader", "etcd", "consul", "http-server"]

  # boot disk
  disk {
    image = "${var.gce_coreos_disk_image}"
  }

  network_interface {
    network = "${google_compute_network.core.name}"
    access_config {
      // ephemeral IP
    }
  }

  metadata {
    user-data = "${file("cloud-config-leader.yaml")}"
  }
}

resource "google_compute_http_health_check" "leader-health-check" {
  name = "leader-health-check"
  description = "Check Leader Pool - GET /health_check each 5sec"
  request_path = "/health_check"
  check_interval_sec = 5
  timeout_sec = 5
}

resource "google_compute_target_pool" "leader-target-pool" {
  name = "leader-target-pool"
  instances = [ "${formatlist("%s/%s", google_compute_instance.core-leader.*.zone, google_compute_instance.core-leader.*.name)}" ]
  health_checks = [ "${google_compute_http_health_check.leader-health-check.name}" ]
}

resource "google_compute_forwarding_rule" "leader-forward-pool-http" {
  name = "leader-forward-pool-http"
  description = "Forward HTTP/80 requests from public-ip to Leader Pool"
  ip_address = "${google_compute_address.core.address}"
  target = "${google_compute_target_pool.leader-target-pool.self_link}"
  port_range = "80"
}

resource "google_compute_forwarding_rule" "leader-forward-pool-https" {
  name = "leader-forward-pool-https"
  description = "Forward HTTPS/443 requests from public-ip to Leader Pool"
  ip_address = "${google_compute_address.core.address}"
  target = "${google_compute_target_pool.leader-target-pool.self_link}"
  port_range = "443"
}

output "public-ip" {
  value = "${google_compute_address.core.address}"
}

output "leader_name" {
  value = "${join(", ", google_compute_instance.core-leader.*.name)}"
}

output "leader_private_address" {
  value = "${join(", ", google_compute_instance.core-leader.*.network_interface.0.address)}"
}

output "leader_public_address" {
  value = "${join(", ", google_compute_instance.core-leader.*.network_interface.0.access_config.0.nat_ip)}"
}

output "fleetctl_remote" {
  value = "fleetctl --tunnel ${google_compute_address.core.address}"
}
