locals {
  availability_zone_a = "${var.region}a"
  availability_zone_b = "${var.region}b"
}


resource "aws_vpc" "versionn-app-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "versionn-app-subnet-public" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.availability_zone_a
}

resource "aws_subnet" "versionn-app-subnet-b" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.availability_zone_b
}

resource "aws_internet_gateway" "versionn-app-ecs-igw" {
  vpc_id = "${aws_vpc.versionn-app-vpc.id}"
}


resource "aws_route_table" "versionn-app-route-table" {
  vpc_id = "${aws_vpc.versionn-app-vpc.id}"
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