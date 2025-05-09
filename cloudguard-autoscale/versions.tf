terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.17.0"
    }
  }
}

