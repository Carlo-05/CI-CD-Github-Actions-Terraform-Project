#Security Group
variable "ASG_template_sg" {
  description = "ASG sg"
}
variable "webapp_target_group" {
  description = "web app target group"
}

#Template
variable "ami" {
  description = "preferred ami for your ASG"
}
variable "instance_type" {
  description = "ASG instance type"
}
variable "key_name" {
  description = "keypair need for your ASG"
}
variable "iam_instance_profile" {
  description = "iam role profile for ASG"
}
variable "subnet-1" {
  description = "public subnet 1 for ASG"
}
variable "subnet-2" {
  description = "public subnet 2 for ASG"
}
#tagging
variable "default_tags" {
  description = "local tags"
  type = map(string)
}
variable "WebApp_ASG_template_tag" {
  description = "ASG template name tag"
}
variable "Webapp_ASG_tag" {
  description = "ASG name"
}


