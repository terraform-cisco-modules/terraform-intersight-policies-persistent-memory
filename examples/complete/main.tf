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
