# Azure CycleCloud Image Build (Ubuntu 24.04 DSVM base)

This Packer definition builds an Azure managed image that starts from the Ubuntu 24.04 DSVM Marketplace image and installs:

- Azure CycleCloud (`cyclecloud8`)
- Azure CLI (`az`)
- CycleCloud CLI (`cyclecloud`)

## Files

- `azure-cyclecloud-ubuntu2404-dsvm.pkr.hcl`: Packer template
- `example.auto.pkrvars.hcl`: Example variables file
- `scripts/install-azure-cli.sh`: Installs Azure CLI
- `scripts/install-cyclecloud.sh`: Installs CycleCloud server and CycleCloud CLI
- `scripts/cleanup.sh`: Cleans package and instance state
- `scripts/deprovision.sh`: Runs Azure image deprovisioning

## Prerequisites

- Packer >= 1.8
- Azure subscription where you can create a temporary VM and publish a managed image
- Either:
  - Azure CLI auth (`az login`) and `use_azure_cli_auth = true` (default), or
  - Service principal credentials (`client_id`, `client_secret`, `tenant_id`)

## Confirm DSVM 24.04 URN in your region

Marketplace image names can differ by region and over time. Verify what is available before building:

```bash
az vm image list \
  --location eastus \
  --publisher microsoft-dsvm \
  --all \
  --query "[?contains(offer, '2404') || contains(sku, '2404')].[offer,sku,version]" \
  -o table
```

If needed, update `image_offer` and `image_sku` in `example.auto.pkrvars.hcl`.

## Build

```bash
packer init .
packer validate -var-file=example.auto.pkrvars.hcl azure-cyclecloud-ubuntu2404-dsvm.pkr.hcl
packer build -var-file=example.auto.pkrvars.hcl azure-cyclecloud-ubuntu2404-dsvm.pkr.hcl
```

## Notes

- If the selected DSVM image requires terms acceptance, you may need:

```bash
az vm image terms accept --publisher <publisher> --offer <offer> --plan <plan>
```

- The resulting image includes CycleCloud software. You still need post-deployment configuration (admin user, SSL, etc.) when the VM is first launched.
