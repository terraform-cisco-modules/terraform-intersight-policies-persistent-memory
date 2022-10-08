#_______________________________________________________________
#
# Collect the moid of the Persistent Memory Policy as an Output
#_______________________________________________________________

output "moid" {
  description = "Persistent Memory Policy Managed Object ID (moid)."
  value       = intersight_memory_persistent_memory_policy.persistent_memory.moid
}
