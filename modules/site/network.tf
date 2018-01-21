# ------------------------------------------------------------------------------
# CONFIGURE OUR NETWORK
# ------------------------------------------------------------------------------

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
    Name = "igw"
  }
}

# ------------------------------------------------------------------------------
# NAT GATEWAYS
# ------------------------------------------------------------------------------

resource "aws_eip" "nat_eip_b" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "nat_gw_b" {
    allocation_id = "${aws_eip.nat_eip_b.id}"
    subnet_id     = "${aws_subnet.public_subnet_b.id}"
    depends_on    = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "nat_eip_c" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "nat_gw_c" {
    allocation_id = "${aws_eip.nat_eip_c.id}"
    subnet_id     = "${aws_subnet.public_subnet_c.id}"
    depends_on    = ["aws_internet_gateway.igw"]
}

# ------------------------------------------------------------------------------
# PUBLIC SUBNETS
# ------------------------------------------------------------------------------

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = true

  tags {
    Name = "public-subnet-c"
  }
}

# ------------------------------------------------------------------------------
# PUBLIC ROUTE TABLES
# ------------------------------------------------------------------------------

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = "${aws_subnet.public_subnet_c.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

# ------------------------------------------------------------------------------
# PRIVATE SUBNETS
# ------------------------------------------------------------------------------

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.3.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = false

  tags {
    Name = "private_subnet_b"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.4.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = false

  tags {
    Name = "private_subnet_c"
  }
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.5.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = false

  tags {
    Name = "private_subnet_b"
  }
}

resource "aws_subnet" "db_subnet_c" {
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "10.1.6.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = false

  tags {
    Name = "private_subnet_c"
  }
}


# ------------------------------------------------------------------------------
# PRIVATE ROUTE TABLES
# ------------------------------------------------------------------------------

resource "aws_route_table" "private_route_table_b" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_b.id}"
  }

  tags {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.private_route_table_b.id}"
}

resource "aws_route_table" "private_route_table_c" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw_c.id}"
  }

  tags {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = "${aws_subnet.private_subnet_c.id}"
  route_table_id = "${aws_route_table.private_route_table_c.id}"
}

# ------------------------------------------------------------------------------
# PUBLIC SECURITY GROUP
# ------------------------------------------------------------------------------

resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------------------------------------------------------------
# PRIVATE SECURITY GROUP
# ------------------------------------------------------------------------------

resource "aws_security_group" "private_sg" {
  name   = "private_sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


# ------------------------------------------------------------------------------
# PUBLIC NCAL
# Reference: https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Appendix_NACLs.html
# ------------------------------------------------------------------------------

resource "aws_network_acl" "public_acl" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  subnet_ids = [
      "${aws_subnet.public_subnet_b.id}",
      "${aws_subnet.public_subnet_c.id}"
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # For ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags {
    Name = "public_acl"
  }
}

# ------------------------------------------------------------------------------
# PRIVATE NCAL
# ------------------------------------------------------------------------------

resource "aws_network_acl" "private_acl" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  subnet_ids = [
      "${aws_subnet.private_subnet_c.id}",
      "${aws_subnet.private_subnet_b.id}",
      "${aws_subnet.db_subnet_b.id}",
      "${aws_subnet.db_subnet_c.id}"
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # For ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 5432
    to_port    = 5432
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 5432
    to_port    = 5432
  }

  tags {
    Name = "private_acl"
  }
}
