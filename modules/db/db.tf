resource "aws_db_instance" "postgres_rds" {
  #depends_on             = ["${var.db_security_group}"]
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
  vpc_security_group_ids = ["${var.db_security_group}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "default" {
  subnet_ids  = ["${var.db_subnet_b}", "${var.db_subnet_c}"]
}
