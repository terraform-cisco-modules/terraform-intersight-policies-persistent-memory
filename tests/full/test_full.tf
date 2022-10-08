module "main" {
  source                 = "../.."
  description            = "${var.name} Persistent Memory Policy."
  management_mode        = "configured-from-intersight"
  memory_mode_percentage = 50
  name                   = var.name
  namespaces = [
    {
      capacity         = 512
      mode             = "raw"
      name             = "default"
      socket_id        = 1
      socket_memory_id = "Not Applicable"
    }
  ]
  organization           = "terratest"
  persistent_memory_type = "app-direct"
  persistent_passphrase  = var.persistent_passphrase
  retain_namespaces      = true
}

variable "persistent_passphrase" {
  default     = ""
  description = "Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are a-z, A to Z, 0-9, and special characters =, \u0021, &, #, $, %, +, ^, @, _, *, -."
  sensitive   = true
  type        = string
}
