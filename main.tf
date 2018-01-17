# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "ap-southeast-2"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR NETWORK
# ------------------------------------------------------------------------------

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags {
    Name = "tf-example"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "main"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "172.16.10.0/24"
  availability_zone = "ap-southeast-2c"
  map_public_ip_on_launch = true
  tags {
    Name = "tf-example"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "main"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.my_subnet.id}"
  route_table_id = "${aws_route_table.r.id}"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR EC2
# ------------------------------------------------------------------------------

resource "aws_instance" "example" {
  ami = "ami-37df2255"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.my_subnet.id}"
  security_groups = ["${aws_security_group.allow_all.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

