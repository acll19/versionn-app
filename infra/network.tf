resource "aws_vpc" "versionn-app-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "versionn-app-subnet" {
  vpc_id     = aws_vpc.versionn-app-vpc.id
}