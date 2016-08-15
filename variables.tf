variable "name" {
    type = "string"
    description = "A logical name for this network.  Affects the naming of resources within it. Example: 'prod'"
}

variable "vpc_cidr_second_octet" {
    type = "string"
    description = "The number ot use for the second octet of this networks CDIR.  Example: '8' results in 10.8.0.0/16"
}

variable "num_azs" {
  default = "3"
  description = "The number of availability_zones to use.  Recommended: 3"
}

variable "public_cidr_third_octet" {
  default = "100"
  description = "The starting third octet for public subnets."
}

variable "private_cidr_third_octet" {
  default = "200"
  description = "The starting third octet for private subnets."
}
