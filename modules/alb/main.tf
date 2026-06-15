resource "aws_lb_target_group" "tg" {
  name     = "production-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    path = "/"
  }
}



resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.tg.arn

  target_id = var.instance_id

  port = 80
}



resource "aws_lb" "alb" {

  name               = "production-alb"

  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = [
    var.public_subnet_1_id,
    var.public_subnet_2_id
  ]
}


resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}
