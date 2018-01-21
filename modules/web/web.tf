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
  image_id             = "ami-37df2255"
  instance_type        = "m3.medium"
  security_groups      = ["${var.private_sg}"]
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  spot_price           = "0.0094"

  user_data = <<-EOF
              #!/bin/bash
              #cd /tmp
              echo "Hello Deloitte Platform Engineering!" > index.html
              nohup busybox httpd -f -p 80 &
              wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
              sudo dpkg -i amazon-ssm-agent.deb
              sudo systemctl enable amazon-ssm-agent
              sudo apt-get install -y postgresql-client
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# INSTANCE PROFILE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_iam_role" "instance_role" {
  name = "instance_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
    role       = "${aws_iam_role.instance_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
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
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}
