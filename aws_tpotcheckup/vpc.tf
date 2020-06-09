resource "aws_vpc" "vpc_TPOT" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        Name = "TPOT VPC"
    }
}

resource "aws_subnet" "pubsn_CPGW" {
    vpc_id                  = "${aws_vpc.vpc_TPOT.id}"
    cidr_block              = "${var.public_subnet_cidr}"
    availability_zone       = "${var.ec2_region}a"
    map_public_ip_on_launch = true

    tags = {
	Name = "CPGW Public Subnet"
    }
}
resource "aws_subnet" "prisn_CPGW" {
    vpc_id                  = "${aws_vpc.vpc_TPOT.id}"
    cidr_block              = "${var.private_subnet_cidr}"
    availability_zone       = "${var.ec2_region}a"
    map_public_ip_on_launch = false

    tags = {
	Name = "CPGW Private Subnet"
    }
}
resource "aws_subnet" "prisn_TPOT" {
    vpc_id                  = "${aws_vpc.vpc_TPOT.id}"
    cidr_block              = "${var.tpot_subnet_cidr}"
    availability_zone       = "${var.ec2_region}a"
    map_public_ip_on_launch = false

    tags = {
	Name = "TPOT Private Subnet"
    }
}

resource "aws_internet_gateway" "igw_TPOT" {
    vpc_id = "${aws_vpc.vpc_TPOT.id}"

    tags = {
	Name = "TPOT IGW"
    }
}

resource "aws_route_table" "publicrt_CPGW" {
    vpc_id     = "${aws_vpc.vpc_TPOT.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw_TPOT.id}"
    }

    tags = {
        Name = "TPOT Public RT"
    }
}

resource "aws_route_table" "privatert_TPOT" {
    vpc_id     = "${aws_vpc.vpc_TPOT.id}"

    route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = "${aws_network_interface.eni_CPGW_private.id}"
    }

    tags = {
        Name = "TPOT Private RT"
    }
}

resource "aws_route_table_association" "publicrta_CPGW" {
    route_table_id = "${aws_route_table.publicrt_CPGW.id}"
    subnet_id = "${aws_subnet.pubsn_CPGW.id}"
}

resource "aws_route_table_association" "privaterta_TPOT" {
    route_table_id = "${aws_route_table.privatert_TPOT.id}"
    subnet_id = "${aws_subnet.prisn_TPOT.id}"
}
