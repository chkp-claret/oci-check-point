resource "oci_core_vcn" "internal" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  cidr_block     = var.vcn_cidr_block
  display_name   = var.vcn_display_name
}

resource "oci_core_subnet" "frontend" {
  count          = local.use_existing_network ? 0 : 1
  display_name   = var.public_subnet_display_name
  cidr_block     = var.public_subnet_cidr_block
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.internal[0].id
  route_table_id = oci_core_route_table.frontend_route_table[0].id
}

resource "oci_core_subnet" "backend" {
  count          = local.use_existing_network ? 0 : 1
  display_name              = var.private_subnet_display_name
  cidr_block                = var.private_subnet_cidr_block
  compartment_id            = var.network_compartment_ocid
  vcn_id                    = oci_core_vcn.internal[0].id
  prohibit_internet_ingress = true
}

resource "oci_core_internet_gateway" "internet_gateway" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.internal[0].id
  enabled        = "true"
  display_name   = "${var.project_name}-internet-gw"
}

resource "oci_core_route_table" "frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.internal[0].id

  display_name = "frontend-routing-table"
  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway[0].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_default_security_list" "allow_all" {
  count          = local.use_existing_network ? 0 : 1
  manage_default_resource_id = oci_core_vcn.internal[0].default_security_list_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "all"
  }
}

resource "oci_network_load_balancer_network_load_balancer" "external_network_load_balancer" {
  compartment_id                 = var.network_compartment_ocid
  display_name                   = "${var.project_name}-external-lb"
  subnet_id                      = local.use_existing_network ? var.public_subnet_id : oci_core_subnet.frontend[0].id
  is_preserve_source_destination = false
  is_private                     = false
}

resource "oci_network_load_balancer_backend_set" "external_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 8117
  }
  name                     = "${var.project_name}-external-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_network_load_balancer.id
  policy                   = "FIVE_TUPLE"
}

resource "oci_network_load_balancer_listener" "external_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.external_backend_set.name
  name                     = "${var.project_name}-external-listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.external_network_load_balancer.id
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_network_load_balancer" "internal_network_load_balancer" {
  compartment_id                 = var.network_compartment_ocid
  display_name                   = "${var.project_name}-internal-lb"
  subnet_id                      = local.use_existing_network ? var.private_subnet_id : oci_core_subnet.backend[0].id
  is_preserve_source_destination = true
  is_private                     = true
  is_symmetric_hash_enabled      = true
}

resource "oci_network_load_balancer_backend_set" "internal_backend_set" {
  health_checker {
    protocol = "TCP"
    port     = 8117
  }
  name                     = "${var.project_name}-internal-backend-set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_network_load_balancer.id
  policy                   = "FIVE_TUPLE"
}

resource "oci_network_load_balancer_listener" "internal_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.internal_backend_set.name
  name                     = "${var.project_name}-internal-listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.internal_network_load_balancer.id
  port                     = 0
  protocol                 = "ANY"
}
