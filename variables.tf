variable "name" {
    type = "string"
    description = "A logical name for this network.  Affects the naming of resources within it. Example: 'prod'"
}

variable "vpc_cidr_second_octet" {
    type = "string"
    description = "The number ot use for the second octet of this networks CDIR.  Example: '8' results in 10.8.0.0/16"
}

# Lookup tables for reuse

variable "az" {
  default = {
    "0" = "us-east-1a"
    "1" = "us-east-1c"
    "2" = "us-east-1d"
  }
}

variable "public_cidr_third_octet" {
  default = {
    "us-east-1a" = "110"
    "us-east-1c" = "130"
    "us-east-1d" = "140"
  }
}

variable "private_cidr_third_octet" {
  default = {
    "us-east-1a" = "210"
    "us-east-1c" = "230"
    "us-east-1d" = "240"
  }
}
