/*
Description:

  Example to deploy deployer(s) using Terrafor Cloud / Enterprise.
*/
module "sap_deployer" {
  source                          = "../../terraform-units/modules/sap_deployer"
  infrastructure                  = local.infrastructure
  deployers                       = local.deployers
  options                         = local.options
  ssh-timeout                     = var.ssh-timeout
  authentication                  = local.authentication
  key_vault                       = local.key_vault
  naming                          = module.sap_namegenerator.naming
  firewall_deployment             = local.firewall_deployment
  assign_subscription_permissions = local.assign_subscription_permissions
  # bootstrap                       = true
}

module "sap_namegenerator" {
  source                          = "../../terraform-units/modules/sap_namegenerator"
  environment                     = lower(local.infrastructure.environment)
  deployer_environment            = lower(local.infrastructure.environment)
  location                        = lower(local.infrastructure.region)
  codename                        = lower(local.infrastructure.codename)
  management_vnet_name            = local.vnet_mgmt_name_part
  random_id                       = module.sap_deployer.random_id
  deployer_vm_count               = local.deployer_vm_count
}