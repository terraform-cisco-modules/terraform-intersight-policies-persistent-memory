<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-persistent-memory/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-persistent-memory/actions/workflows/terratest.yml)

# Terraform Intersight Policies - Persistent Memory
Manages Intersight Persistent Memory Policies

Location in GUI:
`Policies` » `Create Policy` » `Persistent Memory`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

## Example

### main.tf
```hcl
module "persistent_memory" {
  source  = "terraform-cisco-modules/policies-persistent-memory/intersight"
  version = ">= 1.0.1"

  description            = "default Persistent Memory Policy."
  name                   = "default"
  management_mode        = "configured-from-intersight"
  memory_mode_percentage = 50
  namespaces = [
    {
      capacity         = 512
      mode             = "raw"
      name             = "default"
      socket_id        = 1
      socket_memory_id = "Not Applicable"
    }
  ]
  organization           = "default"
  persistent_memory_type = "app-direct"
  retain_namespaces      = true
  persistent_passphrase  = var.persistent_passphrase
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

variable "secure_passphrase" {
  default     = ""
  description = "Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are a-z, A to Z, 0-9, and special characters =, \u0021, &, #, $, %, +, ^, @, _, *, -."
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
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_management_mode"></a> [management\_mode](#input\_management\_mode) | Management Mode of the policy. This can be either Configured from Intersight or Configured from Operating System.<br>* configured-from-intersight - The Persistent Memory Modules are configured from Intersight thorugh Persistent Memory policy.<br>* configured-from-operating-system - The Persistent Memory Modules are configured from operating system thorugh OS tools. | `string` | `"configured-from-intersight"` | no |
| <a name="input_memory_mode_percentage"></a> [memory\_mode\_percentage](#input\_memory\_mode\_percentage) | Volatile memory percentage.  Range is 0-100. | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Namespace is a partition made in one or more Persistent Memory Regions. You can create a namespace in Raw or Block mode.<br>* capacity - Capacity of this Namespace that is created or modified.<br>* mode: (optional) - Mode of this Namespace that is created or modified.<br>  - block - The block mode of Persistent Memory Namespace.<br>  - raw; (default) - The raw mode of Persistent Memory Namespace.<br>* name - Name of the Logical Namespace<br>* socket\_id: (optional) - Default is 1.  Socket ID of the region on which this Namespace has to be created or modified.<br>  - 1: (default) - The first CPU socket in a server.<br>  - 2 - The second CPU socket in a server.<br>  - 3 - The third CPU socket in a server.<br>  - 4 - The fourth CPU socket in a server.<br>* socket\_memory\_id: (optional) - Socket Memory ID of the region on which this Namespace has to be created or modified.<br>  This is only applicable if running in app-direct-non-interleaved mode.  Options are:<br>  - "Not Applicable": (default) - The socket memory ID is not applicable if app-direct persistent memory type is selected in the goal<br>  - 2 - The second socket memory ID within a socket in a server.<br>  - 4 - The fourth socket memory ID within a socket in a server.<br>  - 6 - The sixth socket memory ID within a socket in a server.<br>  - 8 - The eighth socket memory ID within a socket in a server.<br>  - 10 - The tenth socket memory ID within a socket in a server.<br>  - 12 - The twelfth socket memory ID within a socket in a server. | <pre>list(object(<br>    {<br>      capacity         = number<br>      mode             = optional(string, "raw")<br>      name             = string<br>      socket_id        = optional(number, 1)<br>      socket_memory_id = optional(string, "Not Applicable")<br><br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_persistent_memory_type"></a> [persistent\_memory\_type](#input\_persistent\_memory\_type) | Type of the Persistent Memory configuration where the Persistent Memory Modules are combined in an interleaved set or not.<br>* app-direct - The App Direct interleaved Persistent Memory type.<br>* app-direct-non-interleaved - The App Direct non-interleaved Persistent Memory type. | `string` | `"app-direct"` | no |
| <a name="input_persistent_passphrase"></a> [persistent\_passphrase](#input\_persistent\_passphrase) | Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are a-z, A to Z, 0-9, and special characters =, !, &, #, $, %, +, ^, @, \_, *, -. | `string` | `""` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of Profiles to Assign to the Policy.<br>* name - Name of the Profile to Assign.<br>* object\_type - Object Type to Assign in the Profile Configuration.<br>  - server.Profile - For UCS Server Profiles.<br>  - server.ProfileTemplate - For UCS Server Profile Templates. | <pre>list(object(<br>    {<br>      name        = string<br>      object_type = optional(string, "server.Profile")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_retain_namespaces"></a> [retain\_namespaces](#input\_retain\_namespaces) | Persistent Memory Namespaces to be retained or not. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | Persistent Memory Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_memory_persistent_memory_policy.persistent_memory](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/memory_persistent_memory_policy) | resource |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_server_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile) | data source |
| [intersight_server_profile_template.templates](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile_template) | data source |
<!-- END_TF_DOCS -->