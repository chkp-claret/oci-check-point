#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################

variable "tenancy_ocid" {
}

variable "region" {
}

############################
#  Template Information    #
############################

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default = "management"
}

variable "template_version" {
  description = "Template version"
  default = "20250423"
}

variable "template_type" {
  type = string
  default = "terraform"
}

variable "installation_type" {
  description = "Installation type"
  type = string
  default = "management"
}

variable "os_version" {
  description = "GAIA OS version"
  type = string
  default = "R8120"
}

############################
#  Marketplace Image       #
############################

variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = true
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaathapqmj6p7j3rtr3f6oocrncwj2tj5ljc3foaomfe6wg57efwgpq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaatwqxaa42mr23jjumxihug45vlw5p5pcb6wgrphqbyf7pkhpwezzq"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "R81.20_rev2025.02.25"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  Compute Configuration   #
############################

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "vm_display_name" {
  description = "Instance Name"
  default     = "cloudguard-management"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 1
}

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "ssh_public_key" {
  description = "SSH Public Key"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "VFIO"
}

############################
#  Network Configuration   #
############################

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "cloudguard-mgmt-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "management"
}

variable "subnet_id" {
  default = ""
}

variable "subnet_display_name" {
  description = "Subnet Name"
  default     = "subnet"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

############################
# Additional Configuration #
############################

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "management-security-group"
}

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  default     = "true"
}

variable "shell" {
  description = "Change the admin shell to enable advanced command line configuration"
  default     = "/etc/cli.sh"
}

variable "admin_password_hash" {
  description = "Admin user's password hash (use command 'openssl passwd -1 <PASSWORD>' to get the PASSWORD's hash)"
  type = string
}

variable "maintenance_mode_password_hash" {
  description = "Maintenance mode password hash, relevant only for R81.20 and higher versions. Use the command 'grub2-mkpasswd-pbkdf2'"
  type = string
}

variable "hostname" {
  type = string
  description = "(Optional) Security Management Server prompt hostname"
  default = ""
}

variable "management_gui_client_network" {
  description = "Allowed GUI clients - GUI clients network CIDR"
  type = string
  default = "0.0.0.0/0"
}

######################
#    Enum Values     #   
######################
variable "network_strategy_enum" {
  type = map 
  default = { 
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}
