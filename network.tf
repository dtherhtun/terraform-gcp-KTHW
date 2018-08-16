resource "google_compute_network" "kubernetes" {
  name = "${var.network["name"]}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "kubernetes" {
  name          = "kubernetes-${var.region}"
  network       = "${google_compute_network.kubernetes.self_link}"
  ip_cidr_range = "${var.network["iprange"]}"
  region        = "${var.region}"
}

resource "google_compute_address" "controllers" {
  count = "${var.number_of_controller}"
  name = "controller-${count.index}"
  subnetwork = "${google_compute_subnetwork.kubernetes.self_link}"
  address_type = "INTERNAL"
  region = "${var.region}"
  address = "${var.network["prefix"]}.1${count.index}"
}

resource "google_compute_address" "workers" {
  count = "${var.number_of_worker}"
  name = "worker-${count.index}"
  subnetwork = "${google_compute_subnetwork.kubernetes.self_link}"
  address_type = "INTERNAL"
  region = "${var.region}"
  address = "${var.network["prefix"]}.2${count.index}"
}

resource "google_compute_firewall" "kubernetes-allow-icmp" {
  name          = "kubernetes-allow-icmp"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "kubernetes-allow-internal" {
  name          = "kubernetes-allow-internal"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["${var.network["iprange"]}", "10.200.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "kubernetes-allow-rdp" {
  name          = "kubernetes-allow-rdp"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "kubernetes-allow-ssh" {
  name          = "kubernetes-allow-ssh"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "kubernetes-allow-api-server" {
  name          = "kubernetes-allow-api-server"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
}

resource "google_compute_firewall" "kubernetes-allow-healthz" {
  name          = "kubernetes-allow-healthz"
  network       = "${google_compute_network.kubernetes.name}"
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22" ]

  allow {
    protocol = "tcp"
    ports    = ["8080", "80", "${var.kube_api_port}"]
  }
}

resource "google_compute_health_check" "kubernetes-health-check-with-ssl" {
   name = "kubernetes-health-check-with-ssl"
  
   https_health_check {
     host = "kubernetes.default.svc.cluster.local"
     request_path = "/healthz"
     port = "${var.kube_api_port}"
  }
}

resource "google_compute_health_check" "kubernetes-health-check" {
   name = "kubernetes-health-check-without-ssl"

   http_health_check {
     host = "kubernetes.default.svc.cluster.local"
     request_path = "/healthz"
     port = "${var.kube_api_port}"
  }
}



resource "google_compute_address" "kubernetes" {
  name = "kubernetes"
}

resource "google_compute_target_pool" "kubernetes" {
  name = "kubernetes-pool"
  instances = [
    "${var.region}-${var.zones[0]}/controller-0",
    "${var.region}-${var.zones[0]}/controller-1",
    "${var.region}-${var.zones[0]}/controller-2",
  ]
  health_checks = [
#    "${google_compute_health_check.kubernetes-health-check-with-ssl.name}",
  ]
}

resource "google_compute_forwarding_rule" "kubernetes" {
  project               = "${var.project}"
  name                  = "kube-forward"
  ip_address		= "${google_compute_address.kubernetes.address}"
  target                = "${google_compute_target_pool.kubernetes.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "${var.kube_api_port}"
}
