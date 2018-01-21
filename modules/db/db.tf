resource "aws_db_instance" "postgres_rds" {
  depends_on             = ["aws_security_group.default"]
  allocated_storage      = 10
  identifier             = "mydb-rds"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.5"
  instance_class         = "db.t2.micro"
  multi_az               = true
  name                   = "mydb"
  username               = "foo"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${aws_subnet.db_subnet_b.id}", "${aws_subnet.db_subnet_c.id}"]
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id                  = "${var.main_vpc}"
  cidr_block              = "10.1.5.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = false

  tags {
    Name = "db_subnet_b"
  }
}

resource "aws_subnet" "db_subnet_c" {
  vpc_id                  = "${var.main_vpc}"
  cidr_block              = "10.1.6.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = false

  tags {
    Name = "db_subnet_c"
  }
}

resource "aws_security_group" "default" {
  name        = "main_rds_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.main_vpc}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
