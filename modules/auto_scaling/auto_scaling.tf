# ---------------------------------------------------------------------------------------------------------------------
# CREATE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  vpc_zone_identifier = ["${var.subnet_b}", "${var.subnet_c}"]
  min_size             = 2
  max_size             = 10
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "example" {
  image_id        = "ami-37df2255"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

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
# CREATE THE SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name   = "terraform-example-instance"
  vpc_id = "${var.main_vpc}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = ["${aws_security_group.instance.id}"]
  subnets            = ["${var.subnet_b}", "${var.subnet_c}"]

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
