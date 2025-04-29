resource "oci_core_vcn" "vcn" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.vcn_cidr_block
  dns_label      = var.vcn_dns_label
  compartment_id = var.network_compartment_ocid
  display_name   = var.vcn_display_name
}

resource "oci_core_internet_gateway" "igw" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vcn_display_name}-igw"  
  vcn_id         = oci_core_vcn.vcn[count.index].id
  enabled        = "true"
}

resource "oci_core_route_table" "frontend_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.vcn[count.index].id

  display_name = "${var.vcn_display_name}-frontend"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw[count.index].id
  }
}

resource "oci_core_subnet" "public_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.vcn[count.index].id
  cidr_block                 = var.subnet1_cidr_block
  display_name               = var.subnet1_display_name
  route_table_id             = oci_core_route_table.frontend_route_table[0].id
  dns_label                  = var.subnet_dns_label
  prohibit_public_ip_on_vnic = "false"
}

resource "oci_core_subnet" "private_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.vcn[count.index].id
  cidr_block                 = var.subnet2_cidr_block
  display_name               = var.subnet2_display_name
  prohibit_internet_ingress  = true
}
