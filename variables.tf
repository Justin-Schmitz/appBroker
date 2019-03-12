// Google Compute Platform Variables
variable region {
  default         = "us-west1"
}

variable network_name {
  default         = "appsbrokernetwork"
  type            = "string"
  description     = "Network for the appsBroker assignment for GCP"
}

variable gcp_ip_cidr_range {
  default         = "10.0.0.0/16"
  type            = "string"
  description     = "IP CIDR Range for Google VPC."
}

variable subnet_names {
  type            = "map"

  default = {
    subnet1       = "subnet1"
    subnet2       = "subnet2"
  }
}

variable "appsb_ssh_user" {
  default         = "appsbroker"
}

variable "appsb_ssh_pub_key_file" {}