locals {

  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  # marketplace
  mp_subscription_enabled  = var.mp_subscription_enabled ? 1 : 0
  listing_id               = var.mp_listing_id
  listing_resource_id      = var.mp_listing_resource_id
  listing_resource_version = var.mp_listing_resource_version

  is_flex_shape = var.vm_compute_shape == "VM.Standard.E5.Flex" ? [var.vm_flex_shape_ocpus]:[]

  password_hash = replace(var.admin_password_hash, "$", "\\$")
}