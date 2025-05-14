locals {
  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  mp_subscription_enabled  = var.mp_subscription_enabled ? 1 : 0
  listing_id               = var.mp_listing_id
  listing_resource_id      = var.mp_listing_resource_id
  listing_resource_version = var.mp_listing_resource_version

  supported_flex_shapes = ["VM.Standard.E3.Flex", "VM.Standard.E4.Flex", "VM.Optimized3.Flex", "VM.Standard3.Flex", "VM.Standard.E5.Flex"]
  is_flex_shape = contains(local.supported_flex_shapes, var.vm_compute_shape) ? [var.vm_flex_shape_ocpus]:[]

  password_hash = replace(var.admin_password_hash, "$", "\\$")
}
