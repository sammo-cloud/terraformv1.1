################################################
#### Transit Gateway
################################################

resource "aws_ec2_transit_gateway" "tgw_gc" {
  description = "GC TGW"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgwatt_gc" {
  subnet_ids         = [aws_subnet.sn_gc_tgwha_a.id,aws_subnet.sn_gc_tgwha_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
  vpc_id             = aws_vpc.vpc_gc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgwatt_bu1" {
  subnet_ids         = [aws_subnet.sn_bu1_tgwha_a.id,aws_subnet.sn_bu1_tgwha_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
  vpc_id             = aws_vpc.vpc_bu1.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgwatt_bu2" {
  subnet_ids         = [aws_subnet.sn_bu2_tgwha_a.id,aws_subnet.sn_bu2_tgwha_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
  vpc_id             = aws_vpc.vpc_bu2.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_route_table" "tgwrt_transit" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id

  tags = {
      "Name" = "Transit Associated Route Table"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgwrt_spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id

  tags = {
      "Name" = "Spoke Associated Route Table"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgwrta_gc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_gc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_transit.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgwrta_bu1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_bu1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_spoke.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgwrta_bu2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_bu2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_spoke.id
}

resource "aws_ec2_transit_gateway_route" "tgwr_spoke" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_gc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_spoke.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgwrtp_bu1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_bu1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_transit.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgwrtp_bu2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgwatt_bu2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwrt_transit.id
}

################################################
#### Geo-Cluster Transit VPC
################################################
resource "aws_vpc" "vpc_gc" {
    cidr_block           = var.vpc_gc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        "Name" = "GC Transit"
    }
}

resource "aws_subnet" "sn_gc_public_a" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 1)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true

    tags = {
        "Name" = "GC Public subnet 1"
        "Network" = "Public"
    }
}

resource "aws_subnet" "sn_gc_mgmt" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 255)
    availability_zone       = "${var.aws_region}c"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "GC MGMT"
    }
}

resource "aws_subnet" "sn_gc_private_a" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 11)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "GC Private subnet 1"
    }
}

resource "aws_subnet" "sn_gc_tgwha_a" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 201)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "GC TGW HA subnet 1"
    }
}

resource "aws_subnet" "sn_gc_tgwha_b" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 202)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "GC TGW HA subnet 2"
        "Network" = "Private"
    }
}

resource "aws_subnet" "sn_gc_public_b" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 2)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = true

    tags = {
        "Network" = "Public"
        "Name" = "GC Public subnet 2"
    }
}

resource "aws_subnet" "sn_gc_private_b" {
    vpc_id                  = aws_vpc.vpc_gc.id
    cidr_block              = cidrsubnet(var.vpc_gc_cidr, 8, 12)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "GC Private subnet 2"
    }
}

resource "aws_internet_gateway" "igw_gc" {
    vpc_id     = aws_vpc.vpc_gc.id

    tags = {
        "Network" = "Public"
        "Name" = "GC IGW"
    }
}

data "aws_network_interface" "nic_gc_member_a_public" {
  depends_on = [
    aws_cloudformation_stack.checkpoint_gc_cloudformation_stack,
  ]
  filter {
    name   = "subnet-id"
    values = [aws_subnet.sn_gc_public_a.id]
  }
}

data "aws_network_interface" "nic_gc_member_a_private" {
  depends_on = [
    aws_cloudformation_stack.checkpoint_gc_cloudformation_stack,
  ]
  filter {
    name   = "subnet-id"
    values = [aws_subnet.sn_gc_private_a.id]
  }
}

data "aws_instance" "ins_gc_member_a" {
  depends_on = [
    aws_cloudformation_stack.checkpoint_gc_cloudformation_stack,
  ]
  filter {
    name   = "tag:Name"
    values = ["${var.project_name} member A"]
  }
}

data "aws_instance" "ins_management" {
  depends_on = [
    aws_cloudformation_stack.checkpoint_Management_cloudformation_stack,
  ]
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-Management"]
  }
}

resource "aws_route_table" "rt_gc_tgw" {
    vpc_id     = aws_vpc.vpc_gc.id

    route {
        cidr_block = "0.0.0.0/0"
        #instance_id = data.aws_instance.ins_gc_member_a.id
        network_interface_id = data.aws_network_interface.nic_gc_member_a_public.id
    }

    tags = {
        "Name" = "GC TGW Subnets"
    }
}

resource "aws_route_table" "rt_gc_public" {
    vpc_id     = aws_vpc.vpc_gc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_gc.id
    }

    tags = {
        "Name" = "GC Public Subnets"
        "Network" = "Public"
    }
}

resource "aws_route_table" "rt_gc_private" {
    vpc_id     = aws_vpc.vpc_gc.id

    route {
        cidr_block = "0.0.0.0/0"
        #instance_id = data.aws_instance.ins_gc_member_a.id
        network_interface_id = data.aws_network_interface.nic_gc_member_a_private.id
    }

    tags = {
        "Name" = "GC Private Subnets"
    }
}

resource "aws_route_table" "rt_gc_mgmt" {
    vpc_id     = aws_vpc.vpc_gc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_gc.id
    }

    tags = {
        "Name" = "GC MGMT"
    }
}

resource "aws_route_table_association" "rta_gc_public_a" {
    route_table_id = aws_route_table.rt_gc_public.id
    subnet_id = aws_subnet.sn_gc_public_a.id
}

resource "aws_route_table_association" "rta_gc_public_b" {
    route_table_id = aws_route_table.rt_gc_public.id
    subnet_id = aws_subnet.sn_gc_public_b.id
}

resource "aws_route_table_association" "rta_gc_mgmt" {
    route_table_id = aws_route_table.rt_gc_mgmt.id
    subnet_id = aws_subnet.sn_gc_mgmt.id
}

################################################
#### BU1 Spoke VPC
################################################
resource "aws_vpc" "vpc_bu1" {
    cidr_block           = var.vpc_bu1_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        "Name" = "BU1 Spoke"
    }
}

resource "aws_subnet" "sn_bu1_public_a" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 1)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true

    tags = {
        "Name" = "BU1 Public subnet 1"
        "Network" = "Public"
    }
}

resource "aws_subnet" "sn_bu1_private_a" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 11)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU1 Private subnet 1"
    }
}

resource "aws_subnet" "sn_bu1_tgwha_a" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 201)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU1 TGW HA subnet 1"
    }
}

resource "aws_subnet" "sn_bu1_tgwha_b" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 202)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "BU1 TGW HA subnet 2"
        "Network" = "Private"
    }
}

resource "aws_subnet" "sn_bu1_public_b" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 2)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = true

    tags = {
        "Network" = "Public"
        "Name" = "BU1 Public subnet 2"
    }
}

resource "aws_subnet" "sn_bu1_private_b" {
    vpc_id                  = aws_vpc.vpc_bu1.id
    cidr_block              = cidrsubnet(var.vpc_bu1_cidr, 8, 12)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU1 Private subnet 2"
    }
}

resource "aws_internet_gateway" "igw_bu1" {
    vpc_id     = aws_vpc.vpc_bu1.id

    tags = {
        "Network" = "Public"
        "Name" = "BU1 IGW"
    }
}

resource "aws_route_table" "rt_bu1_tgw" {
    vpc_id     = aws_vpc.vpc_bu1.id

    tags = {
        "Name" = "BU1 TGW Subnets"
    }
}

resource "aws_route_table" "rt_bu1_public" {
    vpc_id     = aws_vpc.vpc_bu1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_bu1.id
    }

    route {
        cidr_block = var.vpc_bu2_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
    }

    tags = {
        "Name" = "BU1 Public Subnets"
        "Network" = "Public"
    }
}

resource "aws_route_table" "rt_bu1_private" {
    vpc_id     = aws_vpc.vpc_bu1.id

    route {
        cidr_block = var.vpc_bu2_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
    }

    tags = {
        "Name" = "BU1 Private Subnets"
    }
}

resource "aws_route_table_association" "rta_bu1_public_a" {
    route_table_id = aws_route_table.rt_bu1_public.id
    subnet_id = aws_subnet.sn_bu1_public_a.id
}

resource "aws_route_table_association" "rta_bu1_public_b" {
    route_table_id = aws_route_table.rt_bu1_public.id
    subnet_id = aws_subnet.sn_bu1_public_b.id
}

################################################
#### BU2 Spoke VPC
################################################
resource "aws_vpc" "vpc_bu2" {
    cidr_block           = var.vpc_bu2_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        "Name" = "BU2 Spoke"
    }
}

resource "aws_subnet" "sn_bu2_public_a" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 1)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true

    tags = {
        "Name" = "BU2 Public subnet 1"
        "Network" = "Public"
    }
}

resource "aws_subnet" "sn_bu2_private_a" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 11)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU2 Private subnet 1"
    }
}

resource "aws_subnet" "sn_bu2_tgwha_a" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 201)
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU2 TGW HA subnet 1"
    }
}

resource "aws_subnet" "sn_bu2_tgwha_b" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 202)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Name" = "BU2 TGW HA subnet 2"
        "Network" = "Private"
    }
}

resource "aws_subnet" "sn_bu2_public_b" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 2)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = true

    tags = {
        "Network" = "Public"
        "Name" = "BU2 Public subnet 2"
    }
}

resource "aws_subnet" "sn_bu2_private_b" {
    vpc_id                  = aws_vpc.vpc_bu2.id
    cidr_block              = cidrsubnet(var.vpc_bu2_cidr, 8, 12)
    availability_zone       = "${var.aws_region}b"
    map_public_ip_on_launch = false

    tags = {
        "Network" = "Private"
        "Name" = "BU2 Private subnet 2"
    }
}

resource "aws_internet_gateway" "igw_bu2" {
    vpc_id     = aws_vpc.vpc_bu2.id

    tags = {
        "Network" = "Public"
        "Name" = "BU2 IGW"
    }
}

resource "aws_route_table" "rt_bu2_tgw" {
    vpc_id     = aws_vpc.vpc_bu2.id

    tags = {
        "Name" = "BU2 TGW Subnets"
    }
}

resource "aws_route_table" "rt_bu2_public" {
    vpc_id     = aws_vpc.vpc_bu2.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_bu2.id
    }

    route {
        cidr_block = var.vpc_bu1_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
    }

    tags = {
        "Name" = "BU2 Public Subnets"
        "Network" = "Public"
    }
}

resource "aws_route_table" "rt_bu2_private" {
    vpc_id     = aws_vpc.vpc_bu2.id

    route {
        cidr_block = var.vpc_bu1_cidr
        transit_gateway_id = aws_ec2_transit_gateway.tgw_gc.id
    }

    tags = {
        "Name" = "BU2 Private Subnets"
    }
}

resource "aws_route_table_association" "rta_bu2_public_a" {
    route_table_id = aws_route_table.rt_bu2_public.id
    subnet_id = aws_subnet.sn_bu2_public_a.id
}

resource "aws_route_table_association" "rta_bu2_public_b" {
    route_table_id = aws_route_table.rt_bu2_public.id
    subnet_id = aws_subnet.sn_bu2_public_b.id
}
