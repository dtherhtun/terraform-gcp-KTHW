provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
