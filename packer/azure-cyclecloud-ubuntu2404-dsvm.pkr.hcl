packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID used for the build."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID used for service principal auth (optional with Azure CLI auth)."
  default     = ""
}

variable "client_id" {
  type        = string
  description = "Azure client/application ID used for service principal auth (optional with Azure CLI auth)."
  default     = ""
}

variable "client_secret" {
  type        = string
  description = "Azure client secret used for service principal auth (optional with Azure CLI auth)."
  sensitive   = true
  default     = ""
}

variable "use_azure_cli_auth" {
  type        = bool
  description = "Use the active az login context instead of explicit client credentials."
  default     = true
}

variable "location" {
  type        = string
  description = "Azure region where the image is built."
  default     = "eastus"
}

variable "managed_image_resource_group_name" {
  type        = string
  description = "Existing resource group where the managed image artifact is published."
}

variable "managed_image_name" {
  type        = string
  description = "Managed image name to create. Must be unique per build in the destination RG."
}

variable "build_vm_size" {
  type        = string
  description = "Size of the temporary build VM."
  default     = "Standard_D8s_v5"
}

variable "ssh_username" {
  type        = string
  description = "SSH username used by Packer while provisioning."
  default     = "azureuser"
}

variable "image_publisher" {
  type        = string
  description = "Marketplace publisher for the Ubuntu 24.04 DSVM source image."
  default     = "microsoft-dsvm"
}

variable "image_offer" {
  type        = string
  description = "Marketplace offer for the Ubuntu 24.04 DSVM source image."
  default     = "ubuntu-2404"
}

variable "image_sku" {
  type        = string
  description = "Marketplace SKU for the Ubuntu 24.04 DSVM source image."
  default     = "ubuntu-2404"
}

variable "image_version" {
  type        = string
  description = "Marketplace image version. Keep 'latest' unless pinning is required."
  default     = "latest"
}

# Set these only if the selected DSVM image requires plan acceptance.
variable "plan_name" {
  type        = string
  description = "Marketplace plan name (optional)."
  default     = ""
}

variable "plan_product" {
  type        = string
  description = "Marketplace plan product (optional)."
  default     = ""
}

variable "plan_publisher" {
  type        = string
  description = "Marketplace plan publisher (optional)."
  default     = ""
}

source "azure-arm" "cyclecloud" {
  use_azure_cli_auth = var.use_azure_cli_auth

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  os_type     = "Linux"
  image_offer = var.image_offer
  image_sku   = var.image_sku
  image_publisher = var.image_publisher
  image_version   = var.image_version

  managed_image_resource_group_name = var.managed_image_resource_group_name
  managed_image_name                = var.managed_image_name

  location     = var.location
  vm_size      = var.build_vm_size
  ssh_username = var.ssh_username

  azure_tags = {
    builtBy = "packer"
    role    = "cyclecloud"
  }
}

build {
  name    = "azure-cyclecloud-ubuntu2404-dsvm"
  sources = ["source.azure-arm.cyclecloud"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo -E bash {{ .Path }}"
    script          = "${path.root}/scripts/install-azure-cli.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo -E bash {{ .Path }}"
    script          = "${path.root}/scripts/install-cyclecloud.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo -E bash {{ .Path }}"
    script          = "${path.root}/scripts/cleanup.sh"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo -E bash {{ .Path }}"
    script          = "${path.root}/scripts/deprovision.sh"
  }
}
