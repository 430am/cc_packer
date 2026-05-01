subscription_id                    = "00000000-0000-0000-0000-000000000000"
managed_image_resource_group_name  = "rg-images"
managed_image_name                 = "cyclecloud-ubuntu2404-dsvm-20260501"
location                           = "eastus"

# Keep these defaults unless your region exposes a different DSVM 24.04 URN.
image_publisher = "microsoft-dsvm"
image_offer     = "ubuntu-2404"
image_sku       = "ubuntu-2404"
image_version   = "latest"

# Optional: only needed if the marketplace image requires a purchase plan.
# plan_name      = "..."
# plan_product   = "..."
# plan_publisher = "..."

# If you disable CLI auth, provide service principal credentials.
# use_azure_cli_auth = false
# tenant_id          = "00000000-0000-0000-0000-000000000000"
# client_id          = "00000000-0000-0000-0000-000000000000"
# client_secret      = "super-secret"
