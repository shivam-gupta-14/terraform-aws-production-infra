data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


locals {
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl enable nginx
              systemctl start nginx

              echo "<h1>Terraform ASG Infrastructure</h1>" > /var/www/html/index.html
              EOF
  )
}


resource "aws_launch_template" "web" {

  name_prefix = "web-template-"

  image_id = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  user_data = local.user_data


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-web-server"
    }
  }
}


resource "aws_autoscaling_group" "web" {

  name = "web-asg"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {

    id = aws_launch_template.web.id

    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "asg-web-server"
    propagate_at_launch = true
  }
}



