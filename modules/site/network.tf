# ------------------------------------------------------------------------------
# CONFIGURE OUR NETWORK
# ------------------------------------------------------------------------------

resource "aws_vpc" "main_vpc" {
  cidr_block = "172.16.0.0/16"

  tags {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "gw"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-c"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags {
    Name = "subnet-b"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.subnet_c.id}"
  route_table_id = "${aws_route_table.main_route_table.id}"
}
