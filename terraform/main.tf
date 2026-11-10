terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. إنشاء Resource Group مخصص للمشروع والأمان
resource "azurerm_resource_group" "sec_rg" {
  name     = "rg-secure-landing-zone-prod"
  location = "East US"

  tags = {
    Environment = "Production"
    Compliance  = "CIS-Benchmark"
    ManagedBy   = "Terraform"
  }
}

# 2. إنشاء Virtual Network (VNet) آمنة
resource "azurerm_virtual_network" "sec_vnet" {
  name                = "vnet-secure-landing-zone"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name

  tags = {
    SecurityControl = "NetworkIsolation"
  }
}

# 3. إنشاء Subnet داخل الـ VNet
resource "azurerm_subnet" "sec_subnet" {
  name                 = "snet-internal-workloads"
  resource_group_name  = azurerm_resource_group.sec_rg.name
  virtual_network_name = azurerm_virtual_network.sec_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. إغلاق Network Security Group (NSG) لمنع أي مرور عشوائي (Least Privilege)
resource "azurerm_network_security_group" "sec_nsg" {
  name                = "nsg-restricted-default"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name

  tags = {
    SecurityControl = "RestrictedTraffic"
  }
}

# ربط الـ NSG بالـ Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.sec_subnet.id
  network_security_group_id = azurerm_network_security_group.sec_nsg.id
}

# 5. Log Analytics Workspace لجمع السجلات والتنبيهات (متوافق مع متطلبات Sentinel & Defender)
resource "azurerm_log_analytics_workspace" "sec_law" {
  name                = "law-security-audit-logs"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 365 # الاحتفاظ بالسجلات لمدة سنة كاملة لأجل الامتثال

  tags = {
    Compliance = "AuditLogging"
  }
}

# 6. Storage Account آمن ومؤمن بـ HTTPS والتشفير لتخزين السجلات
resource "azurerm_storage_account" "sec_storage" {
  name                     = "stsecauditlogs2026"
  resource_group_name      = azurerm_resource_group.sec_rg.name
  location                 = azurerm_resource_group.sec_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  
  infrastructure_encryption_enabled = true

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = {
    SecurityControl = "EncryptedStorage"
  }
}