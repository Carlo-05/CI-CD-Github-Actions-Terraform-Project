variable "region" {
  description = "Desired region"
  type = map(string)
  default = {
    "west-1" = "us-west-1",
    "west-2" = "us-west-2"
  }
}
variable "select_region" {
    description = "select between west-1 and west-2"
    type = string  
}

#VPC
variable "vpc_cidr_block" {
  description = "vpc cidr block"
}
variable "public_subnet_count" {
  type = number
  description = "number of public subnet"
}
variable "private_subnet_count" {
  type = number
  description = "number of private subnet"
}

# Key pair
variable "public_key" {
  description = "local public key"
}

# SG
variable "create_ASG_ALB_sg" {
  type = bool
  description = "create asg & alb sg?"
}
variable "create_bastion_sg" {
  type = bool
  description = "create bastion sg?"
}
variable "create_webappinstance_sg" {
  type = bool
  description = "create webapp instance sg?"
}


# SSM parameter store
variable "ssm_db_name" {
  description = "value"
}
variable "ssm_db_username" {
  description = "value"
}
variable "ssm_db_password" {
  description = "value"
}
variable "ssm_db_endpoint" {
  description = "value"
}

#RDS
variable "db_identifier" {
  description = "value"
}
variable "db_engine" {
  description = "value"
}
variable "db_engine_version" {
  description = "value"
}
variable "db_instance_class" {  #change to db.t3.medium for multi-az
  description = "value"
}
variable "db_allocated_storage" {
  description = "value"
}
variable "db_AZ" {
  description = "value"
}
variable "db_multi_az" {
  type = bool
  description = "value"
}

# Webapp/Bastion
variable "ami" {
  description = "Desired region"
  type = map(string)
  default = {
    "linux2" = "ami-0520f976ad2e6300c"
    "ubuntu" = "ami-0606dd43116f5ed57"
    } 
}
variable "select_ami" {
    description = "select ami"
    type = string 
}
variable "instance_type" {
  description = "EC2 instance type"
}



#TAGS
# Local Tag
variable "env" {
  description = "project environment"
}
variable "project_name" {
  description = "project name"
}

# VPC tags
variable "vpc_tag" {
  description = "value"
}
variable "public_RT_tag" {
  description = "value"
}
variable "private_RT1_tag" {
  description = "value"
}
variable "private_RT2_tag" {
  description = "value"
}
variable "igw_tag" {
  description = "value"
}
#SG tags
variable "webapp_sg_tag" {
   description = "value"
}
variable "dbsg_tag" {
  description = "value"
}
variable "bastion_sg_tag" {
  description = "value"
}
variable "ALB_sg_tag" {
  description = "value"
}
variable "ASG_sg_tag" {
  description = "value"
}
variable "public_subnet_tag" {
  description = "value"
}

variable "private_subnet_tag" {
  description = "value"
}
#IAM role tag
variable "iam_role_tag" {
  description = "value"
}

# RDS tags
variable "db_subnetgroup_tag" {
  description = "value"
}

#Keypair tag
variable "keypair_tag" {
  description = "value"
}

#Webapp tag
variable "EC2_webapp_tag" {
  description = "value"
}
#Bastion tag
variable "bastion_tag" {
  description = "value"
}