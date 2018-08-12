data "google_compute_image" "cluster_image" {
  name = "${var.machines["image"]}"
  project = "${var.machines["img_project"]}"
}

resource "google_compute_instance" "etcd-cluster" {
  count        = "${var.number_of_etcd}"
  name         = "etcd-0${count.index}"
  machine_type = "${var.machines["instance-type"]}" 
  zone         = "${var.region}-${element(var.zones, count.index)}"

  can_ip_forward = "true"

  boot_disk {
    initialize_params {
    	image = "${data.google_compute_image.cluster_image.self_link}"
    	size  = "${var.machines["disk-size"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
  }
}

resource "google_compute_instance" "controller-cluster" {
  count        = "${var.number_of_controller}"
  name         = "controller-0${count.index}"
  machine_type = "${var.machines["instance-type"]}"
  zone         = "${var.region}-${var.zones[0]}"

  can_ip_forward = "true"

  boot_disk {
    initialize_params {
    	image = "${data.google_compute_image.cluster_image.self_link}"
    	size  = "${var.machines["disk-size"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
  }
}

resource "google_compute_instance" "worker-cluster" {
  count        = "${var.number_of_worker}"
  name         = "worker-0${count.index}"
  machine_type = "${var.machines["instance-type"]}"
  zone         = "${var.region}-${element(var.zones, count.index)}"

  can_ip_forward = "true"

  boot_disk {
    initialize_params {
    	image = "${data.google_compute_image.cluster_image.self_link}"
    	size  = "${var.machines["disk-size"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
  }
}
