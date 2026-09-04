provider "aws" {
  region = "var.aws_region"
  profile = "var.aws_profile"
}

data "aws_vpc" "default" {
  default = true
}

#create a security group
resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress   {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress    {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg"
  }
}

  #creation of load balancer
  resource "aws_lb_target_group" "my_lb" {
    name     = "my-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id

    health_check {
      path                = "/"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 5
      unhealthy_threshold = 2
      matcher             = "200-299"
    }

    tags = {
      Name = "my-tg"
    }
  }

  resource "aws_lb" "my_lb" {
    name               = "my-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg.id]
    subnets            = data.aws_vpc.default.subnets

    tags = {
      Name = "my-lb"
    }
    
  }
  resource "aws_lb_listener" "my_listener" {
    load_balancer_arn = aws_lb.my_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.my_lb.arn
    }
  }

  #CREATE A AUTOSCALING GROUP
resource "aws_launch_template" "lt" {
    name_prefix = "web-template"
    image_id = "var.ami_id"
    key_name = "var.key_name"
    instance_type = "var.instance_type"
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = filebase64("var.user_data_file")
}

resource "aws_autoscaling_group" "asg" {
    desired_capacity     = "var.desired_capacity"
    max_size             = "var.max_size"
    min_size             = "var.min_size"
    vpc_zone_identifier  = data.aws_vpc.default.subnets
    launch_template {
        id      = aws_launch_template.lt.id
        version = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.my_lb.arn]
}