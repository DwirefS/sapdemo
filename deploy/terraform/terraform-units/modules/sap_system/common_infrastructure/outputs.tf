output "anchor_vm" {
  value = local.anchor_ostype == "LINUX" ? azurerm_linux_virtual_machine.anchor : azurerm_windows_virtual_machine.anchor
}

output "resource_group" {
  value = local.rg_exists ? data.azurerm_resource_group.resource_group : azurerm_resource_group.resource_group
}

output "vnet_sap" {
  value = local.vnet_sap
}

output "storage_bootdiag_endpoint" {
  value = data.azurerm_storage_account.storage_bootdiag.primary_blob_endpoint
}

output "random_id" {
  value = random_id.random_id.hex
}

output "iscsi_private_ip" {
  value = try(var.landscape_tfstate.iscsi_private_ip, [])
}

output "ppg" {
  value = local.ppg_exists ? data.azurerm_proximity_placement_group.ppg : azurerm_proximity_placement_group.ppg
}

output "infrastructure_w_defaults" {
  value = local.infrastructure
}

output "admin_subnet" {
  value = !local.enable_admin_subnet ? null : (local.sub_admin_exists ? data.azurerm_subnet.admin[0] : azurerm_subnet.admin[0])
}

output "db_subnet" {
  value = local.enable_db_deployment ? local.sub_db_exists ? data.azurerm_subnet.db[0] : azurerm_subnet.db[0] : null
}

output "sid_kv_user_id" {
  value = local.enable_sid_deployment && local.use_local_credentials ? (
    azurerm_key_vault.sid_kv_user[0].id) : (
  local.user_key_vault_id)
}

output "sid_kv_prvt_id" {
  value = local.enable_sid_deployment && local.use_local_credentials ? (
    azurerm_key_vault.sid_kv_prvt[0].id) : (
  local.prvt_key_vault_id)
}

output "storage_subnet" {
  value = local.enable_db_deployment && local.enable_storage_subnet ? (
    local.sub_storage_exists ? (
      data.azurerm_subnet.storage[0]) : (
      azurerm_subnet.storage[0]
    )) : (
    null
  )
}

output "sid_password" {
  sensitive = true
  value = local.sid_auth_password
}

output "sid_username" {
  sensitive = true
  value = local.sid_auth_username
}

//Output the SDU specific SSH key
output "sdu_public_key" {
  sensitive = true
  value = local.sid_public_key
}

output "route_table_id" {
  value = local.route_table_id
}

output "firewall_id" {
  value = local.firewall_id
}

output "db_asg_id" {
  value = azurerm_application_security_group.db.id
}

output "use_local_credentials" {
  value = local.use_local_credentials
}
