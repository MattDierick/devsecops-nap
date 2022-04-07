provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-${var.resource_prefix}-acr"
  location = "francecentral"

  tags = {
    environment = "DevSecOps"
    owner = var.resource_email
  }
}

resource "azurerm_container_registry" "acr" {
  name                     = "acr${var.resource_prefix}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true

  tags = {
    environment = "DevSecOps"
    owner = var.resource_email
  }
}

resource "azurerm_resource_group" "default" {
  name     = "${var.resource_prefix}-${var.cluster_name}-rg"
  location = "francecentral"

  tags = {
    environment = "DevSecOps"
    owner = var.resource_email
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${var.cluster_name}-lab-devsecops"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${var.cluster_name}-k8s-lab-devsecops"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "DevSecOps"
    owner = var.resource_email
  }
}
