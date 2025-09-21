output "MyVPC" {
  value = module.VPC.MyVPC
}
output "webapp-public-id" {
  value = module.WEBAPP.webapp_instance_id
}
output "webapp-public-ip" {
  value = module.WEBAPP.webapp_instance_public_ip
}
output "webapp-private-ip" {
  value = module.WEBAPP.webapp_instance_private_ip
}
#RDS
output "rds_endpoint" {
  value = split(":", module.RDS.db_endpoint)[0]
}

