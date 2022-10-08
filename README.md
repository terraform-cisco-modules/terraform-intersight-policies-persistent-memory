<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-power/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-power/actions/workflows/terratest.yml)

# Terraform Intersight Policies - Power
Manages Intersight Power Policies

Location in GUI:
`Policies` » `Create Policy` » `Power`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

## Example

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | >=1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_dynamic_power_rebalancing"></a> [dynamic\_power\_rebalancing](#input\_dynamic\_power\_rebalancing) | Sets the Dynamic Power Rebalancing of the System. This option is only supported for Cisco UCS X series Chassis.<br>  * Enabled - Set the value to Enabled.<br>  * Disabled - Set the value to Disabled. | `string` | `"Enabled"` | no |
| <a name="input_extended_power_capacity"></a> [extended\_power\_capacity](#input\_extended\_power\_capacity) | Sets the Extended Power Capacity of the Chassis. If Enabled, this mode allows chassis available power to be increased by borrowing power from redundant power supplies. This option is only supported for Cisco UCS X series Chassis.<br>  * Enabled - Set the value to Enabled.<br>  * Disabled - Set the value to Disabled. | `string` | `"Enabled"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of Profiles to Assign to the Policy.<br>* name - Name of the Profile to Assign.<br>* object\_type - Object Type to Assign in the Profile Configuration.<br>  - chassis.Profile - For UCS Chassis Profiles.<br>  - server.Profile - For UCS Server Profiles.<br>  - server.ProfileTemplate - For UCS Server Profile Templates. | <pre>list(object(<br>    {<br>      name        = string<br>      object_type = optional(string, "server.Profile")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_power_allocation"></a> [power\_allocation](#input\_power\_allocation) | Sets the Allocated Power Budget of the System (in Watts). This field is only supported for Cisco UCS X series Chassis. | `number` | `0` | no |
| <a name="input_power_priority"></a> [power\_priority](#input\_power\_priority) | Sets the Power Priority of the System. This field is only supported for Cisco UCS X series servers.<br>  * Low - Set the value to Low.<br>  * Medium - Set the value to Medium.<br>  * High - Set the value to High. | `string` | `"Low"` | no |
| <a name="input_power_profiling"></a> [power\_profiling](#input\_power\_profiling) | Sets the Power Profiling of the Server. This field is only supported for Cisco UCS X series servers.<br>  * Enabled - Set the value to Enabled.<br>  * Disabled - Set the value to Disabled. | `string` | `"Enabled"` | no |
| <a name="input_power_redundancy"></a> [power\_redundancy](#input\_power\_redundancy) | Sets the Power Redundancy of the System. N+2 mode is only supported for Cisco UCS X series Chassis.<br>* Grid - Grid Mode requires two power sources. If one source fails, the surviving PSUs connected to the other source provides power to the chassis.<br>* NotRedundant - Power Manager turns on the minimum number of PSUs required to support chassis power requirements. No Redundant PSUs are maintained.<br>* N+1 - Power Manager turns on the minimum number of PSUs required to support chassis power requirements plus one additional PSU for redundancy.<br>* N+2 - Power Manager turns on the minimum number of PSUs required to support chassis power requirements plus two additional PSU for redundancy. This Mode is only supported for UCS X series Chassis. | `string` | `"Grid"` | no |
| <a name="input_power_restore"></a> [power\_restore](#input\_power\_restore) | Sets the Power Restore State of the Server.<br>  * AlwaysOff - Set the Power Restore Mode to Off.<br>  * AlwaysOn - Set the Power Restore Mode to On.<br>  * LastState - Set the Power Restore Mode to LastState. | `string` | `"LastState"` | no |
| <a name="input_power_save_mode"></a> [power\_save\_mode](#input\_power\_save\_mode) | Sets the Power Save mode of the System. This option is only supported for Cisco UCS X series Chassis.<br>  * Enabled - Set the value to Enabled.<br>  * Disabled - Set the value to Disabled. | `string` | `"Enabled"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | Power Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_power_policy.power](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/power_policy) | resource |
| [intersight_chassis_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/chassis_profile) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_server_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile) | data source |
| [intersight_server_profile_template.templates](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile_template) | data source |
<!-- END_TF_DOCS -->