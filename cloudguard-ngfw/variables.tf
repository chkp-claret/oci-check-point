#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

############################
#  Marketplace Image      #
############################

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


############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "cloudguard-ngfw"
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

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "cloudguard-ngfw-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "simple"
}

variable "subnet1_type" {
  description = "Choose between private and public subnets"
  default     = "Use Public Subnet"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "subnet1_id" {
  default = ""
}

variable "subnet1_display_name" {
  description = "Subnet Name"
  default     = "frontend-subnet"
}

variable "subnet1_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "subnet2_type" {
  description = "Choose between private and public subnets"
  default     = "Use Private Subnet"
}

variable "subnet2_id" {
  default = ""
}

variable "subnet2_display_name" {
  description = "Subnet Name"
  default     = "backend-subnet"
}

variable "subnet2_cidr_block" {
  description = "Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

############################
# Additional Configuration #
############################

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "gateway-security-group"
}

variable "routetable_display_name" {
  description = "Route table Name"
  default     = "simple-route-table"
}

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  default     = "true"
}

variable "shell" {
  description = "Change the admin shell to enable advanced command line configuration"
  default     = "/etc/cli.sh"
}

variable "sic_key" {
  description = "The Secure Internal Communication key creates trusted connections between Check Point components. Choose a random string consisting of at least 12 alphanumeric characters"
}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default = "single"
}

variable "template_version" {
  description = "Template version"
  default = "20250423"
}

variable "template_type" {
  type    = string
  default = "terraform"
}

variable "installation_type" {
  type = string
  default = "gateway"
}

variable "os_version" {
  type = string
  default = "R8120"
}

variable "hostname" {
  type = string
  description = "(Optional) Security Gateway prompt hostname"
  default = ""
}

variable "admin_password_hash" {
  description = "Admin user's password hash (use command 'openssl passwd -1 <PASSWORD>' to get the PASSWORD's hash)"
  type = string
}

variable "maintenance_mode_password_hash" {
  description = "Maintenance mode password hash, relevant only for R81.20 and higher versions. Use the command 'grub2-mkpasswd-pbkdf2'"
  type = string
}

variable "enable_metrics" {
  description = "Enable CloudGuard metrics in order to send statuses and statistics collected from instances to the OCI Monitor service."
  type = string
  default = "true"
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

variable "subnet_type_enum" {
  type = map 
  default = { 
    PRIVATE_SUBNET = "Private Subnet"
    PUBLIC_SUBNET  = "Public Subnet"
  }
}

variable "nsg_config_enum" {
  type = map 
  default = { 
    BLOCK_ALL_PORTS = "Block all ports"
    OPEN_ALL_PORTS  = "Open all ports"
    CUSTOMIZE       = "Customize ports - Post deployment"
  }
}

