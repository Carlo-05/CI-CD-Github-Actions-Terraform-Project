variable "vpc_id" {
  description = "preferres vpc"
}
variable "create_bastion_sg" {
  type = bool
  description = "create bastion or not?"
}
variable "create_webappinstance_sg" {
  type = bool
  description = "create ec2 webapp?"
}
variable "create_ASG_ALB_sg" {
  type = bool
  description = "create ASG & ALB sg"
}

#tags
variable "default_tags" {
  description = "local tags"
}
#RDS tags
variable "dbsg_tag" {
    description = "db sg name tag."
}
#bastion tags
variable "bastion_sg_tag" {
    description = "bastion sg name tag"  
}
#ASG tags
variable "ASG_sg_tag" {
  description = "ASG name tag"
}
#ALB tags
variable "ALB_sg_tag" {
  description = "ALB name tag"
}
#webapp tags
variable "webapp_sg_tag" {
  description = "webapp name tag"
}
