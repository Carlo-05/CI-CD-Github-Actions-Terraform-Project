output "MyVPC" {
  value = module.VPC
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
output "db_az" {
  value = module.VPC.vpc_az[0]
}
