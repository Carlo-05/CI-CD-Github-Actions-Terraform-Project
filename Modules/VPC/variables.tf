variable "vpc_cidr_block" {
    description = "Desired VPC cidr bloc"  
}
variable "public_subnet_count" {
  type = number
  default = 0
  description = "desired number of public subnet"
}
variable "private_subnet_count" {
  type = number
  default = 0
  description = "desired number of private subnet"  
}
variable "region" {
  description = "root region"
}
variable "env" {
  description = "Environment"
}
# Resources Tags
variable "default_tags" {
    type = map(string)
    description = "local tags in your root main.tf"
}
variable "vpc_tag" {
    description = "Name tag."  
}
variable "igw_tag" {
    description = "Name Tag"  
}
variable "public_subnet_tag" {
    description = "Name tag." 
}
variable "private_subnet_tag" {
    description = "Name tag." 
}
variable "public_RT_tag" {
    description = "Name tag."  
}
variable "private_RT1_tag" {
    description = "Name tag."  
}
variable "private_RT2_tag" {
    description = "Name tag."  
}

