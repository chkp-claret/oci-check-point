resource "oci_core_instance" "simple-vm" {
  depends_on          = [oci_core_app_catalog_subscription.mp_image_subscription]
  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape


  dynamic "shape_config" {
    for_each = local.is_flex_shape
      content {
        ocpus = shape_config.value
      }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.subnet1_id : oci_core_subnet.public_subnet[0].id
    display_name           = var.vm_display_name
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    skip_source_dest_check = true
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }
  
  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("scripts/cloud-init.sh",{
      installation_type     = var.installation_type
      template_name         = var.template_name
      template_version      = var.template_version
      template_type         = var.template_type
      admin_shell           = var.shell
      sic_key               = var.sic_key
      allow_upload_download = var.allow_upload_download
      password_hash         = local.password_hash
      os_version            = var.os_version
      host_name             = var.hostname
      enable_metrics        = var.enable_metrics
      maintenance_mode_password_hash = var.maintenance_mode_password_hash
    }))
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
}

resource "oci_core_vnic_attachment" "add_vnic" {
  create_vnic_details {
    assign_public_ip       = false
    display_name           = "Secondary"
    skip_source_dest_check = true
    subnet_id              = local.use_existing_network ? var.subnet2_id : oci_core_subnet.private_subnet[0].id
  }
  instance_id  = oci_core_instance.simple-vm.id
}
