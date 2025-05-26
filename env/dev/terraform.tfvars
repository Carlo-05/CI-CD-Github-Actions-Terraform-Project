select_region = "west-2"
#VPC
vpc_cidr_block = "10.0.0.0/16"
public_subnet_count = 2
private_subnet_count = 2
# SG
create_ASG_ALB_sg = false
create_bastion_sg = false
create_webappinstance_sg = true
#Parameter store
ssm_db_name = "/projectdb/database" 
ssm_db_username = "/projectdb/username"
ssm_db_password = "/projectdb/password"
ssm_db_endpoint = "/projectdb/endpoint"

#RDS
db_identifier = "projectdb"
db_engine = "mysql"
db_engine_version = "8.0"
db_instance_class = "db.t3.micro" #change to db.t3.medium for multi-az
db_allocated_storage = "20"
db_AZ = "us-west-2a"
db_multi_az = false

#Bastion/Webapp
select_ami = "ubuntu"
instance_type = "t2.micro"
#TAGS
env ="GitHub-Action"
project_name = "cicd-GitHub-Action"

#vpc tags
vpc_tag = "MyVPC"
public_subnet_tag = "public"
private_subnet_tag = "private"
public_RT_tag = "public-rt"
private_RT1_tag ="private-rt-1"
private_RT2_tag ="private-rt-2"
igw_tag = "MyIgw"
#SG tags
webapp_sg_tag = "Webappsg-GitHub-Action"
dbsg_tag = "dbsg-GitHub-Action"
bastion_sg_tag = "bastionsg-GitHub-Action"

ALB_sg_tag = "MyALB-sg"
ASG_sg_tag = "asg-sg"

#IAM role tag
iam_role_tag = "GitHub-Action-role"
#RDS tags
db_subnetgroup_tag = "db-subnet-group-GitHub-Action"
#Keypair tag
keypair_tag = "GitHub-Action-key"
#Webapp tag
EC2_webapp_tag = "webapp-GitHub-Action"
#Bastion tag
bastion_tag = "bastionhost-GitHub-Action"
