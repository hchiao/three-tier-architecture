# ------------------------------------------------------------------------------
# CONFIGURE OUR EC2
# ------------------------------------------------------------------------------

resource "aws_instance" "example" {
  ami             = "ami-37df2255"
  instance_type   = "t2.micro"
  subnet_id       = "${var.instance_subnet}"
  security_groups = ["${var.instance_security_group}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "hello_world_instance"
  }
}
