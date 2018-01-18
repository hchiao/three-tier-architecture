# ---------------------------------------------------------------------------------------------------------------------
# Module Output
# ---------------------------------------------------------------------------------------------------------------------

output "main_vpc" {
  value = "${aws_vpc.main_vpc.id}"
}

output "public_subnet_b" {
  value = "${aws_subnet.public_subnet_b.id}"
}

output "public_subnet_c" {
  value = "${aws_subnet.public_subnet_c.id}"
}

output "private_subnet_b" {
  value = "${aws_subnet.private_subnet_b.id}"
}

output "private_subnet_c" {
  value = "${aws_subnet.private_subnet_c.id}"
}

output "public_sg" {
  value = "${aws_security_group.public_sg.id}"
}

output "private_sg" {
  value = "${aws_security_group.private_sg.id}"
}
