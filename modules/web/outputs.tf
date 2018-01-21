output "elb_dns" {
  value = "${aws_elb.elb.dns_name}"
}
