output "rds_endpoint" {
  value = "${aws_db_instance.postgres_rds.endpoint}"
}
