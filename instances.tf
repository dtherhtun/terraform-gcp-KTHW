data "google_compute_image" "cluster_image" {
  name = "${var.machines["image"]}"
  project = "${var.machines["img_project"]}"
}

#resource "google_compute_instance" "etcd-cluster" {
#  count        = "${var.number_of_etcd}"
#  name         = "etcd-0${count.index}"
#  machine_type = "${var.machines["instance-type"]}" 
#  zone         =  "${var.region}-${var.zones[2]}"  #"${var.region}-${element(var.zones, count.index)}"

#  can_ip_forward = "true"

#  boot_disk {
#    initialize_params {
#    	image = "${data.google_compute_image.cluster_image.self_link}"
#    	size  = "${var.machines["disk-size"]}"
#    }
#  }
#
#  network_interface {
#    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
#  }
#}

resource "google_compute_instance" "controller-cluster" {
  count        = "${var.number_of_controller}"
  name         = "controller-${count.index}"
  machine_type = "${var.machines["instance-type"]}"
  zone         = "${var.region}-${var.zones[2]}"

  can_ip_forward = "true"

  boot_disk {
    initialize_params {
    	image = "${data.google_compute_image.cluster_image.self_link}"
    	size  = "${var.machines["disk-size"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    #subnetwork = "${element(google_compute_address.controllers.*.address, count.index)}"
    #subnetwork = "${google_compute_address.controllers.network}"
    access_config {

    }
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}

resource "google_compute_instance" "worker-cluster" {
  count        = "${var.number_of_worker}"
  name         = "worker-${count.index}"
  machine_type = "${var.machines["instance-type"]}"
  zone         = "${var.region}-${var.zones[2]}"   #"${var.region}-${element(var.zones, count.index)}"

  can_ip_forward = "true"

  metadata {
    pod-cidr = "10.200.${count.index}.0/24"
  }

  boot_disk {
    initialize_params {
    	image = "${data.google_compute_image.cluster_image.self_link}"
    	size  = "${var.machines["disk-size"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.kubernetes.name}"
    #subnetwork = "${element(google_compute_address.workers.*.address, count.index )}"
    #subnetwork = "${google_compute_address.workers.name}"
    access_config {

    }
  }
  
  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}
