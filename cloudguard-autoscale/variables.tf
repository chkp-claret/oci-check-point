variable "tenancy_ocid" {
  type    = string
}

variable "region" {
  type = string
}

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = true
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaahcc2ffdraf4if3eat2j5doivedtv7wwzpoa4tvhvjfdcozshmgeq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaaaqicewqn7rj44bvjv6blskmtxg7u3kwsinlb4adxkcmpje737xea"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "R81.20_JHF65_rev2.0"
  description = "Marketplace Listing Package/Resource Version"
}

variable "ssh_public_key" {
  type = string
}

variable "vm_compute_shape" {
  type    = string
  default = "VM.Standard2.2"
}

variable "vm_flex_shape_ocpus" {
  type = string
  default = 1
}

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "cloudguard-autoscale-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_id" {
  default = ""
}

variable "public_subnet_display_name" {
  description = "Subnet Name"
  default     = "frontend-subnet"
}

variable "public_subnet_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "private_subnet_id" {
  default = ""
}

variable "private_subnet_display_name" {
  description = "Subnet Name"
  default     = "frontend-subnet"
}

variable "private_subnet_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "sic_key" {
  type    = string
}

variable "template_name" {
  type    = string
  default = "autoscale"
}

variable "template_version" {
  type    = string
  default = "20250509"
}

variable "template_type" {
  type    = string
  default = "terraform"
}

variable "shell" {
  type    = string
  default = "/bin/bash"
}

variable "os_version" {
  type = string
  default = "R8120"
}

variable "admin_password_hash" {
  description = "Admin user's password hash (use command 'openssl passwd -1 <PASSWORD>' to get the PASSWORD's hash)"
  type = string
}

variable "maintenance_mode_password_hash" {
  description = "Maintenance mode password hash, relevant only for R81.20 and higher versions. Use the command 'grub2-mkpasswd-pbkdf2'"
  type = string
}

variable "allow_upload_download" {
  type    = string
  default = "true"
}

variable "project_name" {
  type = string
  description = "All resources created in this stack will be tagged with this name"
}

variable "host_name" {
  type = string
  description = "(Optional) Security Gateway prompt hostname"
  default = ""
}

variable "mgmt_name" {
  type = string
}

variable "configuration_template" {
  type = string
}

variable "mgmt_interface" {
  type = string
  default = "eth0"
}

variable "mgmt_ip" {
  type = string
  default = "public"
}

variable "enable_metrics" {
  type = string
  default = "true"
}

variable "scale_max" {
  type = number
  default = 2
}

variable "scale_min" {
  type = number
  default = 1
}

variable "scale_out_threshold" {
  type = number
  default = 80
}

variable "scale_in_threshold" {
  type = number
  default = 20
}

variable "network_strategy_enum" {
  type = map 
  default = { 
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}
