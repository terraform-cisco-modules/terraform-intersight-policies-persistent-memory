#____________________________________________________________
#
# Persistent Memory Policy Variables Section.
#____________________________________________________________

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "management_mode" {
  default     = "configured-from-intersight"
  description = <<-EOT
    Management Mode of the policy. This can be either Configured from Intersight or Configured from Operating System.
    * configured-from-intersight - The Persistent Memory Modules are configured from Intersight thorugh Persistent Memory policy.
    * configured-from-operating-system - The Persistent Memory Modules are configured from operating system thorugh OS tools.
  EOT
  type        = string
}

variable "memory_mode_percentage" {
  default     = 0
  description = "Volatile memory percentage.  Range is 0-100."
  type        = number
}

variable "name" {
  default     = "default"
  description = "Name for the Policy."
  type        = string
}

variable "namespaces" {
  default     = []
  description = <<-EOT
    Namespace is a partition made in one or more Persistent Memory Regions. You can create a namespace in Raw or Block mode.
    * capacity - Capacity of this Namespace that is created or modified.
    * mode: (optional) - Mode of this Namespace that is created or modified.
      - block - The block mode of Persistent Memory Namespace.
      - raw; (default) - The raw mode of Persistent Memory Namespace.
    * name - Name of the Logical Namespace
    * socket_id: (optional) - Default is 1.  Socket ID of the region on which this Namespace has to be created or modified.
      - 1: (default) - The first CPU socket in a server.
      - 2 - The second CPU socket in a server.
      - 3 - The third CPU socket in a server.
      - 4 - The fourth CPU socket in a server.
    * socket_memory_id: (optional) - Socket Memory ID of the region on which this Namespace has to be created or modified.
      This is only applicable if running in app-direct-non-interleaved mode.  Options are:
      - "Not Applicable": (default) - The socket memory ID is not applicable if app-direct persistent memory type is selected in the goal
      - 2 - The second socket memory ID within a socket in a server.
      - 4 - The fourth socket memory ID within a socket in a server.
      - 6 - The sixth socket memory ID within a socket in a server.
      - 8 - The eighth socket memory ID within a socket in a server.
      - 10 - The tenth socket memory ID within a socket in a server.
      - 12 - The twelfth socket memory ID within a socket in a server.
  EOT
  type = list(object(
    {
      capacity         = number
      mode             = optional(string, "raw")
      name             = string
      socket_id        = optional(number, 1)
      socket_memory_id = optional(string, "Not Applicable")

    }
  ))
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "persistent_memory_type" {
  default     = "app-direct"
  description = <<-EOT
    Type of the Persistent Memory configuration where the Persistent Memory Modules are combined in an interleaved set or not.
    * app-direct - The App Direct interleaved Persistent Memory type.
    * app-direct-non-interleaved - The App Direct non-interleaved Persistent Memory type.
  EOT
  type        = string
}

variable "persistent_passphrase" {
  default     = ""
  description = "Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are a-z, A to Z, 0-9, and special characters =, \u0021, &, #, $, %, +, ^, @, _, *, -."
  sensitive   = true
  type        = string
}

variable "profiles" {
  default     = []
  description = <<-EOT
    List of Profiles to Assign to the Policy.
    * name - Name of the Profile to Assign.
    * object_type - Object Type to Assign in the Profile Configuration.
      - server.Profile - For UCS Server Profiles.
      - server.ProfileTemplate - For UCS Server Profile Templates.
  EOT
  type = list(object(
    {
      name        = string
      object_type = optional(string, "server.Profile")
    }
  ))
}

variable "retain_namespaces" {
  default     = true
  description = "Persistent Memory Namespaces to be retained or not."
  type        = bool
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}

