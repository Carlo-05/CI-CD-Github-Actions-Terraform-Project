# Create EIP
resource "aws_eip" "EIP" {
  domain = "vpc"
  tags = merge(var.default_tags, {Name = var.EIP_tag})
}
#Create NatGateway
resource "aws_nat_gateway" "Test-Nat" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = var.NAT-Subnet

  tags = merge(var.default_tags, {Name = var.NatGateway_tag})
}
# Attached existing route table to your NatGateway
resource "aws_route" "private1-RTable-attached-to-Test-Nat" {
  route_table_id         = var.Private-RT-1  # Replace with your existing private route table ID
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Test-Nat.id
}
