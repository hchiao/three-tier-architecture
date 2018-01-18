# ---------------------------------------------------------------------------------------------------------------------
# AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  vpc_zone_identifier = ["${var.private_subnet_b}", "${var.private_subnet_c}"]
  min_size             = 2
  max_size             = 10
  load_balancers       = ["${aws_elb.elb.name}"]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "autoscaling_group"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "launch_configuration" {
  image_id        = "ami-37df2255"
  instance_type   = "t2.micro"
  security_groups = ["${var.private_sg}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Deloitte DPE!" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ELB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elb" "elb" {
  name               = "elb"
  security_groups    = ["${var.private_sg}", "${var.public_sg}"]
  subnets            = ["${var.public_subnet_b}", "${var.public_subnet_c}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
}
