resource "aws_alb_target_group" "ubuntu-web" {
  name     = "ubuntu-web-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_target_group_attachment" "ubuntu-web" {
  count            = length(var.ec2.*.id)
  target_group_arn = aws_alb_target_group.ubuntu-web.arn
  target_id        = var.ec2.*.id[count.index]
  port             = 80
}

resource "aws_alb" "ubuntu-web" {
  name               = "ubuntu-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ec2_sg]
  subnets            = var.subnet_id

  enable_deletion_protection = false

}

resource "aws_alb_listener" "ubuntu-web" {
  load_balancer_arn = aws_alb.ubuntu-web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ubuntu-web.arn
  }
}