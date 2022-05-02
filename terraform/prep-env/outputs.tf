output "client_key" {
   value = azurerm_kubernetes_cluster.default.kube_config.0.client_key
   sensitive = true
}

output "client_certificate" {
   value = azurerm_kubernetes_cluster.default.kube_config.0.client_certificate
   sensitive = true
}

output "cluster_ca_certificate" {
   value = azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate
   sensitive = true
}

output "cluster_fqdn" {
   value = azurerm_kubernetes_cluster.default.kube_config.0.fqdn
   sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
  sensitive = true
}

output "acr_server" {
  value = azurerm_container_registry.acr.login_server
  sensitive = true
}

output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}
