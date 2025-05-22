# db sg
output "db_sg" {
    value = aws_security_group.db_sg.id  
}
# bastion sg
output "bastion_sg" {
    value = try(aws_security_group.bastion-sg[0].id, null)
}
# webapp sg
output "Web_app_sg" {
    value = try(aws_security_group.Web-app-sg[0].id, null) 
}
# alb sg
output "alb_sg" {
  value = try(aws_security_group.ALB-sg[0].id, null)
}
# asg sg
output "asg_sg" {
  value = try(aws_security_group.ASG_template_sg[0].id, null)
}