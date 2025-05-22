
variable "vpc_id" {
  description = "vpc for my ALB"
}
variable "ALB-sg" {
  description = "ALB security group"
}
variable "alb_logs_prefix" {
  description = "alb logs"
}

variable "subnet-1" {
  description = "subnet 1 for the ALB to forward traffic"
}
variable "subnet-2" {
  description = "subnet 2 for the ALB to forward traffic"
}
#s3
variable "s3_bucket_ALB_logs" {
  description = "s3 bucket for ALB logs"
}
#tagging
variable "default_tags" {
    description = "local tags"  
}
variable "webapp_target_group_tag" {
  description = "webapp target group name tag"
}
variable "webapp_ALB_tag" {
  description = "ALB name tag"
}
variable "ALB_listener_tag" {
  description = "ALB listener name tag"
}