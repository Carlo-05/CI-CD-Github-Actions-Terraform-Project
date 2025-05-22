
locals {
 region = var.region
 availability_zones = ["${var.region}a", "${var.region}b"] 
}

# VPC
resource "aws_vpc" "MyVPC" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, { Name = var.vpc_tag })
}

# Internet Gateway
resource "aws_internet_gateway" "MyGW" {
  vpc_id = aws_vpc.MyVPC.id

  tags = merge(var.default_tags, { Name = var.igw_tag })
}

# Create Public Subnets
resource "aws_subnet" "Public-1" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = element(local.availability_zones, count.index % 2)
  map_public_ip_on_launch = true
  

  tags = merge(var.default_tags, { Name = "${var.public_subnet_tag}-${count.index + 1}" })
}

# Create Private Subnets Application
resource "aws_subnet" "Private-1" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 10)
  availability_zone = element(local.availability_zones, count.index % 2)

  tags = merge(var.default_tags, { Name = "${var.private_subnet_tag}-${count.index + 1}" })
}

# Route Table for public subnets
resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.MyVPC.id
  tags = merge(var.default_tags, { Name = var.public_RT_tag })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyGW.id
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "Public-RTA-1" {
  count = length(aws_subnet.Public-1)
  subnet_id      = aws_subnet.Public-1[count.index].id
  route_table_id = aws_route_table.Public-Route-Table.id
}

# Private Route Table App
resource "aws_route_table" "Private-Route-Table-1" {
  vpc_id = aws_vpc.MyVPC.id
  tags = merge(var.default_tags, { Name = var.private_RT1_tag })
}
# Private Route Table db
resource "aws_route_table" "Private-Route-Table-2" {
  vpc_id = aws_vpc.MyVPC.id
  tags = merge(var.default_tags, { Name = var.private_RT2_tag })
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "Private-RTA-1" {
  count = length(aws_subnet.Private-1)
  subnet_id      = aws_subnet.Private-1[count.index].id
  route_table_id = count.index < 2 ? aws_route_table.Private-Route-Table-1.id : aws_route_table.Private-Route-Table-2.id
}


