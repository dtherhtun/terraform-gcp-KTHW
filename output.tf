output "addresses" {
  value = "${join(",", google_compute_address.kubernetes.*.address)}"
}

#output "etcd_id_list" {
#  description = "Instance ip list"
#  value = "${join(" ", google_compute_instance.etcd-cluster.*.network_interface.0.address)}"
#}

output "master_ip_list" {
  description = "Master ip list"
  value       = "${join(" ", google_compute_instance.controller-cluster.*.network_interface.0.address)}"
}

output "worker_ip_list" {
  description = "worker ip list"
  value       = "${join(" ", google_compute_instance.worker-cluster.*.network_interface.0.address)}"
}

