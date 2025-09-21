provider "aws" {
  region = lookup(var.region, var.select_region, "us-west-2")
}

locals {
    default_tags = {
  Environment = var.env
  Project = var.project_name
  }
}

#VPC
module "VPC" {
  source = "../../Modules/VPC"
  vpc_cidr_block = var.vpc_cidr_block
  region = lookup(var.region, var.select_region, "us-west-2")
  public_subnet_count = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  env = var.env
  #Tags
  default_tags = local.default_tags
  vpc_tag = var.vpc_tag
  public_subnet_tag = var.public_subnet_tag
  private_subnet_tag = var.private_subnet_tag
  public_RT_tag = var.public_RT_tag
  private_RT1_tag = var.private_RT1_tag
  private_RT2_tag = var.private_RT2_tag
  igw_tag = var.igw_tag
}

# Security Group
module "SG" {
  source = "../../Modules/SECURITYGROUPS"
  create_ASG_ALB_sg = var.create_ASG_ALB_sg
  create_bastion_sg = var.create_bastion_sg
  create_webappinstance_sg = var.create_webappinstance_sg
  vpc_id = module.VPC.MyVPC
  #tags
  default_tags = local.default_tags
  webapp_sg_tag = var.webapp_sg_tag
  dbsg_tag = var.dbsg_tag
  bastion_sg_tag = var.bastion_sg_tag
  ALB_sg_tag = var.ALB_sg_tag
  ASG_sg_tag = var.ASG_sg_tag
}

#NAT
module "NAT" {
  source = "../../Modules/NAT"
  NAT-Subnet = module.VPC.public-subnets[0]
  Private-RT-1 = module.VPC.private-route-table-1
  #tags
  default_tags = local.default_tags
  NatGateway_tag = var.NatGateway_tag
  EIP_tag = var.EIP_tag
}
#ec2 IAM role
module "IAMROLE" {
  source = "../../Modules/IAM-ROLE"
  # Tags
  default_tags = local.default_tags
  iam_role_tag = var.iam_role_tag
}

#Key Pair
module "KEYPAIR" {
  source = "../../Modules/KEYPAIR"
  public_key = var.public_key
  #tags
  default_tags = local.default_tags
  keypair_tag = var.keypair_tag
}

#SSM parameter
data "aws_ssm_parameter" "db_username" {
  name = var.ssm_db_username
}
data "aws_ssm_parameter" "db_password" {
  name = var.ssm_db_password
  with_decryption = true
}
data "aws_ssm_parameter" "db_name" {
  name = var.ssm_db_name
}

# RDS 
module "RDS" {
  source = "../../Modules/RDS-MYSQL"
  #subnet group
  db_subnet_private1 = module.VPC.private-subnets[2]
  db_subnet_private2 = module.VPC.private-subnets[3]
  #Security group
  vpc_id = module.VPC.MyVPC
  db_sg = module.SG.db_sg  
  #databse config
  db_identifier = var.db_identifier
  db_engine = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class #change to db.t3.medium for multi-az
  db_allocated_storage = var.db_allocated_storage
  db_name = data.aws_ssm_parameter.db_name.value
  db_username = data.aws_ssm_parameter.db_username.value
  db_password = data.aws_ssm_parameter.db_password.value
  db_AZ = var.db_multi_az ? null : module.VPC.vpc_az[0]
  db_multi_az = var.db_multi_az
  #tags
  default_tags = local.default_tags
  db_subnetgroup_tag = var.db_subnetgroup_tag
  db_tag = format("%s-GitHub-Action", data.aws_ssm_parameter.db_name.value)
}
#Create a resource that export rds enpoint to ssm parameter
resource "aws_ssm_parameter" "db_host" {
  name = var.ssm_db_endpoint
  type = "String"
  value = split(":", module.RDS.db_endpoint)[0]
}

# Bastion Host
module "BASTION" {
  source = "../../Modules/BASTION"
  ami = lookup(var.ami, var.select_ami, "ami-0606dd43116f5ed57")
  instance_type = var.instance_type
  subnet_id = module.VPC.public-subnets[1]
  bastion_sg = module.SG.bastion_sg
  key_name = module.KEYPAIR.key_name
  #tags
  default_tags = local.default_tags
  bastion_tag = var.bastion_tag
}

# ALB 
module "ALB" {
  source = "../../Modules/ALB"
  vpc_id = module.VPC.MyVPC
  subnet-1 = module.VPC.public-subnets[0]
  subnet-2 = module.VPC.public-subnets[1]
  ALB-sg = module.SG.alb_sg
  s3_bucket_ALB_logs = var.s3_bucket_ALB_logs
  alb_logs_prefix = var.alb_logs_prefix
  #tags
  default_tags = local.default_tags
  ALB_listener_tag = var.ALB_listener_tag
  webapp_target_group_tag = var.webapp_target_group_tag
  webapp_ALB_tag = var.webapp_ALB_tag


}

# ASG
module "ASG" {
  source = "../../Modules/ASG"
  ami = lookup(var.ami, var.select_ami, "ami-0606dd43116f5ed57")
  instance_type = var.instance_type
  subnet-1 = module.VPC.private-subnets[0]
  subnet-2 = module.VPC.private-subnets[1]
  ASG_template_sg = module.SG.asg_sg
  iam_instance_profile = module.IAMROLE.iam_instance_profile
  key_name = module.KEYPAIR.key_name
  webapp_target_group = [module.ALB.webapp_target_group]
  #tags
  default_tags = local.default_tags
  Webapp_ASG_tag = var.Webapp_ASG_tag
  WebApp_ASG_template_tag = var.WebApp_ASG_template_tag



}


