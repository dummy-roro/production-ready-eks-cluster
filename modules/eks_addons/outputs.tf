output "addon_names" {
  value = keys({ for addon in var.addons : addon.name => addon })
}
