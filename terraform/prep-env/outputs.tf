# output "id" {
#   value = azurerm_kubernetes_cluster.aks_cluster.id
# }

# output "resource_group" {
#   value       = azurerm_resource_group.aks_resources.name
#   description = "Resource Group"
# }

# output "cluster_name" {
#   value       = azurerm_kubernetes_cluster.aks_cluster.name
#   description = "Cluster Name"
# }


#output "kube_config" {
#  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
#  sensitive = true
#}

# output "client_key" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
# }

# output "cluster_ca_certificate" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
# }

# output "host" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
# }

#output "z_az_kubectl_help" {
#  value = "You can import your created cluster kubeconfig into your local using the command: \n az aks get-credentials --resource-group ${azurerm_resource_group.aks_resources.name} --name ${azurerm_kubernetes_cluster.aks_cluster.name}"
#}

output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw

  sensitive = true
}