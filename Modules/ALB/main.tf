#Create ALB target group
resource "aws_alb_target_group" "webapp_target_group" {
  name     = var.webapp_target_group_tag
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    path                = "/" # default path for http and https
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  
  tags = merge(var.default_tags, { Name = var.webapp_target_group_tag })

}
# s3 bucket
data "aws_s3_bucket" "ALB_logs" {
  bucket = var.s3_bucket_ALB_logs
}
# Create ALB
resource "aws_lb" "webapp_ALB" {
  name               = var.webapp_ALB_tag
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB-sg]
  subnets            = [var.subnet-1, var.subnet-2]

  access_logs {
    bucket  = data.aws_s3_bucket.ALB_logs.bucket
    prefix  = var.alb_logs_prefix
    enabled = true
  }

  tags = merge(var.default_tags, { Name = var.webapp_ALB_tag})
}

# Create ALB listener
resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.webapp_ALB.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.webapp_target_group.arn

  }

  tags = merge(var.default_tags, { Name = var.ALB_listener_tag })

  
}

