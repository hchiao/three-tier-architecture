# ---------------------------------------------------------------------------------------------------------------------
# Module Output
# ---------------------------------------------------------------------------------------------------------------------

output "instance_subnet" {
  value = "${aws_subnet.subnet_c.id}"
}

output "instance_security_group" {
  value = "${aws_security_group.allow_http.id}"
}

output "main_vpc" {
  value = "${aws_vpc.main_vpc.id}"
}

output "subnet_b" {
  value = "${aws_subnet.subnet_b.id}"
}

output "subnet_c" {
  value = "${aws_subnet.subnet_c.id}"
}
