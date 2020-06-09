variable "admin_ip" {
  default     = ["0.0.0.0/0"]
  description = "admin IP addresses in CIDR format"
}

variable "ec2_region" {
  description = "AWS region to launch servers"
  default     = "ap-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.254.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.254.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.254.1.0/24"
}

variable "tpot_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.254.11.0/24"
}

variable "CPGW_eth0_primary_ip" {
  description = "CPGW external facing private IP"
  default = "10.254.0.10"
}

variable "CPGW_eth0_secondary_ip" {
  description = "CPGW external facing private IP"
  default = "10.254.0.11"
}

variable "CPGW_eth1_ip" {
  description = "CPGW internal facing private IP"
  default = "10.254.1.10"
}

variable "TPOT_eth0_ip" {
  description = "TPOT private IP"
  default = "10.254.11.10"
}

# https://aws.amazon.com/ec2/instance-types/
# t3.large = 2 vCPU, 8 GiB RAM
variable "tpot_instance_type" {
  default = "t3.large"
}

variable "cp_instance_type" {
  default = "m5.large"
}

variable "pwd_hash" {
  default = "$1$u03P.Y5J$QfPAKLgelKNVZj0EjDSME/"
}

# Refer to https://wiki.debian.org/Cloud/AmazonEC2Image/Buster
variable "tpot_ami" {
  default = {
    "ap-east-1"      = "ami-b7d0abc6"
    "ap-northeast-1" = "ami-01f4f0c9374675b99"
    "ap-northeast-2" = "ami-0855cb0c55370c38c"
    "ap-south-1"     = "ami-00d7d1cbdcb087cf3"
    "ap-southeast-1" = "ami-03779b1b2fbb3a9d4"
    "ap-southeast-2" = "ami-0ce3a7c68c6b1678d"
    "ca-central-1"   = "ami-037099906a22f210f"
    "eu-central-1"   = "ami-0845c3902a6f2af32"
    "eu-north-1"     = "ami-e634bf98"
    "eu-west-1"      = "ami-06a53bf81914447b5"
    "eu-west-2"      = "ami-053d9f0770cd2e34c"
    "eu-west-3"      = "ami-060bf1f444f742af9"
    "me-south-1"     = "ami-04a9a536105c72d30"
    "sa-east-1"      = "ami-0a5fd18ed0b9c7f35"
    "us-east-1"      = "ami-01db78123b2b99496"
    "us-east-2"      = "ami-010ffea14ff17ebf5"
    "us-west-1"      = "ami-0ed1af421f2a3cf40"
    "us-west-2"      = "ami-030a304a76b181155"
  }
}

# Refer to https://s3.amazonaws.com/CloudFormationTemplate/amis.json
variable "r8040_standalone_ami" {
  default = {
    "ap-east-1" = "ami-09cc7152e66599a12"
    "ap-northeast-1" = "ami-064a101a5ba961713"
    "ap-northeast-2" = "ami-05b0bc6726e54d234"
    "ap-south-1" = "ami-0cbbaf8a48e085998"
    "ap-southeast-1" = "ami-0e536e6750055581a"
    "ap-southeast-2" = "ami-0ba565e32b47820bc"
    "ca-central-1" = "ami-01114c04d228a5be0"
    "eu-central-1" = "ami-02ede4641fa88486b"
    "eu-north-1" = "ami-0825f30d7c138c8d7"
    "eu-west-1" = "ami-0247d8569973f1ce6"
    "eu-west-2" = "ami-0ded472ff4aa88e7c"
    "eu-west-3" = "ami-0945fc1e25740bff1"
    "me-south-1" = "ami-0d34dab8985bd2934"
    "sa-east-1" = "ami-0f7b9f5393c67ef45"
    "us-east-1" = "ami-002e3de342bc2ca40"
    "us-east-2" = "ami-0a5edcd578083992e"
    "us-gov-east-1" = "ami-dc7694ad"
    "us-gov-west-1" = "ami-5587a434"
    "us-west-1" = "ami-02e91ae3e6eb08d5f"
    "us-west-2" = "ami-0d1be37d36022c142"
  }
}
