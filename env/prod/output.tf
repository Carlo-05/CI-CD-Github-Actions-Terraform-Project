output "MyVPC" {
  value = module.VPC.MyVPC
}
output "public-subnets" {
  value = module.VPC.public-subnets
}
output "private-subnets" {
  value = module.VPC.private-subnets
}
# ALB
output "ALB-dns" {
  value = module.ALB.ALB_dns
}
# Bastion
output "bastion_public_ip" {
  value = module.BASTION.bastion_ip
}