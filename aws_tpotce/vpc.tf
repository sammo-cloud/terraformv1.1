resource "aws_vpc" "vpc-TPOT" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        Name = "TPOT VPC"
    }
}

resource "aws_subnet" "pubsn-TPOT" {
    vpc_id                  = "${aws_vpc.vpc-TPOT.id}"
    cidr_block              = "${var.public_subnet_cidr}"
    availability_zone       = "${var.ec2_region}c"
    map_public_ip_on_launch = true

    tags = {
	Name = "TPOT Public Subnet"
    }
}

resource "aws_internet_gateway" "igw-TPOT" {
    vpc_id = "${aws_vpc.vpc-TPOT.id}"

    tags = {
	Name = "TPOT IGW"
    }
}

resource "aws_route_table" "publicrt-TPOT" {
    vpc_id     = "${aws_vpc.vpc-TPOT.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw-TPOT.id}"
    }

    tags = {
        Name = "TPOT Public RT"
    }
}

resource "aws_route_table_association" "publicrta-TPOT" {
    route_table_id = "${aws_route_table.publicrt-TPOT.id}"
    subnet_id = "${aws_subnet.pubsn-TPOT.id}"
}
