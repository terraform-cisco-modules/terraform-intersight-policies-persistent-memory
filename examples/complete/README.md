<!-- BEGIN_TF_DOCS -->
# Power Policy Example

### main.tf
```hcl
module "power_policy" {
  source  = "terraform-cisco-modules/policies-power/intersight"
  version = ">= 1.0.1"

  description               = "default Power Policy."
  power_allocation          = 8400
  power_priority            = "Low"
  power_profiling           = "Enabled"
  power_redundancy          = "Grid"
  power_restore             = "LastState"
  power_save_mode           = "Enabled"
  dynamic_power_rebalancing = "Enabled"
  name                      = "default"
  organization              = "default"
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

To run this example you need to execute:

```bash
terraform init
terraform plan -out="main.plan"
terraform apply "main.plan"
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.
<!-- END_TF_DOCS -->