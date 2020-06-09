variable "aws_region" {
    default = "ap-southeast-1"
}

variable "vpc_gc_cidr" {
  default     = "10.254.0.0/16"
}

variable "vpc_bu1_cidr" {
  default     = "10.1.0.0/16"
}

variable "vpc_bu2_cidr" {
  default     = "10.2.0.0/16"
}

variable "cpversion" {
    default = "R80.40"
}

variable "management_server_size" {
    default = "m5.xlarge"
}

variable "geocluster_gateway_size" {
    default = "c5.large"
}

variable "project_name" {
    default = "Geo-Cluster"
}

#Please use your own key to create a password hash and copy it to here.
variable "key_name" {
    default = "Use Your Key"
}

variable "sickey" {
    default = "vpn12345"
}

#Please use "openssl passwd -1" to create a password hash and copy it to here.
variable "password_hash" {
    default = "xxxxxxxxxxxx"
}

