variable "ami" {
    description = "desired ami"  
}
variable "instance_type" {
    description = "desired instance type"  
}
variable "subnet_id" {
    description = "desired subnet for your bastion host"
}

variable "key_name" {
    description = "desired key pair for yor bastion host"
}
variable "bastion_sg" {
  description = "bastion host sg"
}
# Tagging
variable "default_tags" {
    description = "project tag"
  
}

variable "bastion_tag" {
    description = "bastion name tag"
  
}


