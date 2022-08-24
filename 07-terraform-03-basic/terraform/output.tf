output "internal_ip_address_nodes_yandex_cloud" {
  value = yandex_compute_instance.nodes.0.network_interface.0.ip_address
}

output "external_ip_address_nodes_yandex_cloud" {
  value = yandex_compute_instance.nodes.0.network_interface.0.nat_ip_address
}