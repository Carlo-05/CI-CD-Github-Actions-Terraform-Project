
#Create db subnet group
resource "aws_db_subnet_group" "db_subnetgroup" {
    subnet_ids = [ var.db_subnet_private1, var.db_subnet_private2 ]
    name = "db_subnetgroup"
    tags = merge(var.default_tags, { Name = var.db_subnetgroup_tag })
  
}

#Create db
resource "aws_db_instance" "projectdb" {
    identifier = var.db_identifier
    engine = var.db_engine
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class
    allocated_storage = var.db_allocated_storage
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.db_subnetgroup.name
    vpc_security_group_ids = [var.db_sg]
    availability_zone = var.db_AZ
    multi_az = var.db_multi_az
    skip_final_snapshot = true
    publicly_accessible = false
    backup_retention_period = 0

    tags = merge(var.default_tags, { Name = var.db_tag })
}