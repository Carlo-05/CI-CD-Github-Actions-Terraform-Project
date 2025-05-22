variable "db_identifier" {
  description = "preferred db identifier."
}
variable "db_engine" {
  description = "preffered db engine"
}
variable "db_engine_version" {
  description = "preferred db version"
}
variable "db_instance_class" {
  description = "preferred instance class"
}
variable "db_allocated_storage" {
  description = "preferred storage size"
}
variable "db_name" {
  description = "name of your db inside rds"
}
variable "db_username" {
  description = "preferred db username"
}
variable "db_AZ" {
    description = "preferred az for your db"  
}
variable "db_multi_az" {
  description = "single instance or multi-az"
  type = bool
}
variable "db_password" {
  description = "sb password store in ssm parameter store"
}
variable "vpc_id" {
  description = "Desire vpc"
}
variable "db_sg" {
  description = "db security group"
}

variable "db_subnet_private1" {
  description = "private subnet for your db."
}
variable "db_subnet_private2" {
  description = "private subnet for your db."
}
#Tagging
variable "default_tags" {
    description = "local tags"  
}
variable "db_subnetgroup_tag" {
    description = "subnet group name tag"  
}

variable "db_tag" {
    description = "db name tag"  
}