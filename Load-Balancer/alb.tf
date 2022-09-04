resource "aws_lb_target_group" "alb-demo" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }

  name = "whiz-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "application-lb" {
    name = "whiz-alb"
    internal = false
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_server.id]
    # for_each = toset(data.aws_subnets.subnet.ids)
    subnets = data.aws_subnet_ids.subnet.ids

    tags = {
      "Name" = "whiz-alb"
    }
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.application-lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      target_group_arn = aws_lb_target_group.alb-demo.arn
      type = "forward"
    }
  
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  count = length(aws_instance.Demo)
  target_group_arn = aws_lb_target_group.alb-demo.arn
  target_id = aws_instance.Demo[count.index].id
}
