output "MyVPC" {
  value = module.VPC.MyVPC
}
#RDS
output "rds_endpoint" {
  value = split(":", module.RDS.db_endpoint)[0]
}
# ALB
output "ALB-dns" {
  value = module.ALB.ALB_dns
}
# Bastion
output "bastion_public_ip" {
  value = module.BASTION.bastion_ip

}
