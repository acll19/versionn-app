locals {
  availability_zone_a = "${var.region}a"
  availability_zone_b = "${var.region}b"
}


resource "aws_vpc" "versionn-app-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "versionn-app-subnet-a" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.availability_zone_a
}

resource "aws_subnet" "versionn-app-subnet-b" {
  vpc_id            = aws_vpc.versionn-app-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.availability_zone_b
}

resource "aws_internet_gateway" "versionn-app_ecs_igw" {
  vpc_id = "${aws_vpc.versionn-app-vpc.id}"
}
