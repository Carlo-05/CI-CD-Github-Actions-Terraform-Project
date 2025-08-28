
output "public-subnets" {
  value = aws_subnet.Public-1[*].id  
}
output "private-subnets" {
  value = aws_subnet.Private-1[*].id  
}

output "MyVPC" {
  value = aws_vpc.MyVPC.id  
}
output "vpc_az" {
  value = local.availability_zones
}

output "private-route-table-1" {
  value = aws_route_table.Private-Route-Table-1.id  
}
output "private-route-table-2" {
  value = aws_route_table.Private-Route-Table-2[*].id  
}
output "public-route-table" {
  value = aws_route_table.Public-Route-Table.id
  

}
