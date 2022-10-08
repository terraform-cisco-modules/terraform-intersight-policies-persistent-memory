#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name = each.value
}

#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight Persistent Memory Policy
# GUI Location: Policies > Create Policy > Persistent Memory
#__________________________________________________________________

locals {
  secure_passphrase = var.persistent_passphrase != "" ? true : false
}

resource "intersight_memory_persistent_memory_policy" "persistent_memory" {
  depends_on = [
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates
  ]
  description       = var.description != "" ? var.description : "${var.name} Persistent Memory Policy."
  management_mode   = var.management_mode
  name              = var.name
  retain_namespaces = var.retain_namespaces
  goals {
    memory_mode_percentage = var.memory_mode_percentage
    object_type            = "memory.PersistentMemoryGoal"
    persistent_memory_type = var.persistent_memory_type
    socket_id              = "All Sockets"
  }
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "local_security" {
    for_each = {
      for v in compact([var.name]
      ) : var.name => v if local.secure_passphrase == true
    }
    content {
      object_type       = "memory.PersistentMemoryLocalSecurity"
      enabled           = var.persistent_passphrase != "" ? true : false
      secure_passphrase = var.persistent_passphrase
    }
  }
  dynamic "logical_namespaces" {
    for_each = { for v in var.namespaces : v.name => v }
    content {
      capacity         = logical_namespaces.value.capacity
      mode             = logical_namespaces.value.mode
      name             = logical_namespaces.key
      object_type      = "memory.PersistentMemoryLocalSecurity"
      socket_id        = logical_namespaces.value.socket_id
      socket_memory_id = logical_namespaces.value.socket_memory_id
    }
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v.name => v }
    content {
      moid = length(regexall("server.ProfileTemplate", profiles.value.object_type)
        ) > 0 ? data.intersight_server_profile_template.templates[profiles.value.name].results[0
      ].moid : data.intersight_server_profile.profiles[profiles.value.name].results[0].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
