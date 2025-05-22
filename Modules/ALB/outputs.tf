output "ALB_dns" {
  value = aws_lb.webapp_ALB.dns_name
}
output "webapp_target_group" {
  value = aws_alb_target_group.webapp_target_group.arn
}