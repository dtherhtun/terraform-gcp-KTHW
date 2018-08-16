variable "project" {
  default = "engaged-symbol-187009"
}

variable "region" {
  default = "us-west1"
}

variable "network" {
  type = "map"

  default = {
    "name"    = "kubernetes"
    "iprange" = "10.240.0.0/24"
    "prefix"  = "10.240.0"
  }
}

variable "machines" {
  type = "map"

  default = {
    "instance-type" = "n1-standard-1"
    "img_project"   = "ubuntu-os-cloud"
    "image"         = "ubuntu-1604-xenial-v20180814"
    "disk-size"     = 200
  }
}

variable "zones" {
  type = "list"

  default = ["a", "b", "c"]
}

#variable "number_of_etcd" {
#  default = 3
#}

variable "number_of_controller" {
  default = 3
}

variable "number_of_worker" {
  default = 3
}

variable "kube_api_port" {
  default = "6443"
}

