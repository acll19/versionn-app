locals {
  availability_zone_a = "${var.region}a"
  availability_zone_b = "${var.region}b"
}


resource "aws_vpc" "versionn-app-vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.app_prefix}-vpc"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}

resource "aws_subnet" "versionn-app-subnet-public" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.availability_zone_a

  tags {
    Name = "${var.app_prefix}-subnet-public"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}

resource "aws_subnet" "versionn-app-subnet-b" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.availability_zone_b

  tags {
    Name = "${var.app_prefix}-subnet-b"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}

resource "aws_internet_gateway" "versionn-app-ecs-igw" {
  vpc_id = "${aws_vpc.versionn-app-vpc.id}"

  tags {
    Name = "${var.app_prefix}-internet-gateway"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}


resource "aws_route_table" "versionn-app-route-table" {
  vpc_id = "${aws_vpc.versionn-app-vpc.id}"

  tags {
    Name = "${var.app_prefix}-route-table"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}

resource aws_route "versionn-app-public-route" {
  route_table_id         = "${aws_route_table.versionn-app-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.versionn-app-ecs-igw.id}"
}

resource "aws_route_table_association" "versionn-app-route-table-association-public" {
  subnet_id      = "${aws_subnet.versionn-app-subnet-public.id}"
  route_table_id = "${aws_route_table.versionn-app-route-table.id}"
}

resource "aws_eip" "versionn-app-elastic-ip" {
  vpc = true

  tags {
    Name = "${var.app_prefix}-elastic-ip"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}

resource "aws_nat_gateway" "versionn-app-ecs-ngw" {
  allocation_id = "${aws_eip.versionn-app-elastic-ip.id}" 
  subnet_id = "${aws_subnet.versionn-app-subnet-public.id}" 

  tags {
    Name = "${var.app_prefix}-nat-gateway"
    App    = "${var.app_prefix}-app"
    Domain = "version"
  }
}