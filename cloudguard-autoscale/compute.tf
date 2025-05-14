resource "oci_core_instance_configuration" "as_instance_config" {
  compartment_id = var.compute_compartment_ocid
  display_name   = "${var.project_name}-instance-config"

  instance_details {
    instance_type = "compute"
    launch_details {
      freeform_tags = {"x-chkp-management" = var.mgmt_name, "x-chkp-template" = var.configuration_template, "x-chkp-ip-address" = var.mgmt_ip, "x-chkp-management-interface" = var.mgmt_interface}	
      compartment_id = var.compute_compartment_ocid
      shape          = var.vm_compute_shape
      dynamic "shape_config" {
        for_each = local.is_flex_shape
          content {
            ocpus = shape_config.value
          }
      }
      source_details {
        source_type = "image"
        image_id    = local.listing_resource_id
      }
      metadata = {
        ssh_authorized_keys = var.ssh_public_key
        user_data = base64encode(templatefile("scripts/cloud_init.sh", {
          template_name                  = var.template_name
          template_version               = var.template_version
          template_type                  = var.template_type
          admin_shell                    = var.shell
          sic_key                        = var.sic_key
          allow_upload_download          = var.allow_upload_download
          password_hash                  = local.password_hash
          os_version                     = var.os_version
          host_name                      = var.host_name
          enable_metrics                 = var.enable_metrics
          maintenance_mode_password_hash = var.maintenance_mode_password_hash
        }))
      }
      create_vnic_details {
        assign_public_ip       = true
        skip_source_dest_check = true
        subnet_id              = local.use_existing_network ? var.public_subnet_id : oci_core_subnet.frontend[0].id
        display_name           = "gw-frontend"
        freeform_tags = {"x-chkp-topology" = "external", "x-chkp-anti-spoofing" = false}
      }
    }
    secondary_vnics {
      create_vnic_details {
        assign_public_ip       = false
        display_name           = "gw-backend"
        skip_source_dest_check = true
        subnet_id              = local.use_existing_network ? var.private_subnet_id : oci_core_subnet.backend[0].id
        freeform_tags = {"x-chkp-topology" = "internal", "x-chkp-anti-spoofing" = false}
      }
      display_name = "gw-backend"
    }
  }
}

resource "oci_core_instance_pool" "as_instance_pool" {
  compartment_id            = var.compute_compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.as_instance_config.id
  display_name   = "${var.project_name}-instance-pool"
  placement_configurations {
    availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

    primary_subnet_id = local.use_existing_network ? var.public_subnet_id : oci_core_subnet.frontend[0].id
    secondary_vnic_subnets {
      display_name = "gw-backend"
      subnet_id    = local.use_existing_network ? var.private_subnet_id : oci_core_subnet.backend[0].id
    }
  }
  size = var.scale_min

  load_balancers {
    backend_set_name = oci_network_load_balancer_backend_set.external_backend_set.name
    load_balancer_id = oci_network_load_balancer_network_load_balancer.external_network_load_balancer.id
    port             = 8081
    vnic_selection   = "PrimaryVnic"
  }
  load_balancers {
    backend_set_name = oci_network_load_balancer_backend_set.internal_backend_set.name
    load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_network_load_balancer.id
    port             = 0
    vnic_selection   = "gw-backend"
  }
}

resource "oci_autoscaling_auto_scaling_configuration" "as_auto_scaling_configuration" {
  display_name   = "${var.project_name}-autoscaling-config"
  auto_scaling_resources {
    id   = oci_core_instance_pool.as_instance_pool.id
    type = "instancePool"
  }
  compartment_id = var.compute_compartment_ocid
  policies {
    policy_type = "threshold"
    capacity {
      initial = var.scale_min
      max     = var.scale_max
      min     = var.scale_min
    }
    display_name = "${var.project_name}-as-policy"
    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "1"
      }
      display_name = "scale-out-rule"
      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "GT"
          value    = var.scale_out_threshold
        }
      }
    }
    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }
      display_name = "scale-in-rule"
      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "LT"
          value    = var.scale_in_threshold
        }
      }
    }
  }
  is_enabled = true
}
