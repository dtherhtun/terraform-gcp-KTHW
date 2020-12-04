data "google_compute_image" "cluster_image" {
  name    = "${var.machines["image"]}"
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
    address    = "${element(google_compute_address.controllers.*.address, count.index)}"
    access_config {

    }
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
  metadata_startup_script = <<SCRIPT
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && apt-get install -y kubelet kubeadm kubectl
SCRIPT
}

resource "google_compute_instance" "worker-cluster" {
  count        = "${var.number_of_worker}"
  name         = "worker-${count.index}"
  machine_type = "${var.machines["instance-type"]}"
  zone         = "${var.region}-${var.zones[2]}" #"${var.region}-${element(var.zones, count.index)}"

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
    address    = "${element(google_compute_address.workers.*.address, count.index)}"
    access_config {

    }
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata_startup_script = <<SCRIPT
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && apt-get install -y kubelet kubeadm kubectl
SCRIPT

}
