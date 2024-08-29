variable "vpcblock" {
  description = "VPC cidr:"
  sensitive = true
}

variable "subnetwebblock" {
  description = "web subnet cidr:"
  sensitive = true
}

variable "subnetdbblock" {
  description = "db subnet cidr:"
  sensitive = true
}

variable "az" {
  description = "AZ:"
}

resource "aws_vpc" "mar-vpc" {
  cidr_block = var.vpcblock
  tags = {
    Name = "mar-vpc_${terraform.workspace}"
  }
}

resource "aws_subnet" "websubnet" {
  vpc_id     = aws_vpc.mar-vpc.id
  cidr_block = var.subnetwebblock
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "websubnet"
  }
}

resource "aws_subnet" "dbsubnet" {
  vpc_id     = aws_vpc.mar-vpc.id
  cidr_block = var.subnetdbblock
  availability_zone       = var.az
  map_public_ip_on_launch = true
  
  tags = {
    Name = "dbsubnet"
  }
}

resource "aws_internet_gateway" "mar_igway" {
  vpc_id = aws_vpc.mar-vpc.id
  tags = {
    "name" = "mar_igway"
  }
}

resource "aws_route_table" "mar_rt" {
  vpc_id = aws_vpc.mar-vpc.id
}

resource "aws_route" "mar_route" {
  route_table_id         = aws_route_table.mar_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mar_igway.id
}

resource "aws_route_table_association" "mar_rt-assoc" {
  route_table_id = aws_route_table.mar_rt.id
  subnet_id      = aws_subnet.websubnet.id
}

resource "aws_security_group" "mar_sg" {
  name        = "mar_ssh_sg"
  vpc_id      = aws_vpc.mar-vpc.id
  description = "web server sg"
}

resource "aws_vpc_security_group_ingress_rule" "mar_igress_22" {
  security_group_id = aws_security_group.mar_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "122.13.0.55/32"
}

resource "aws_vpc_security_group_ingress_rule" "mar_igress_80" {
  security_group_id = aws_security_group.mar_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "mar_egress" {
  security_group_id = aws_security_group.mar_sg.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
}

output "subnet_out" {
  value = aws_subnet.websubnet.id
}

output "sg_out" {
  value = aws_security_group.mar_sg.id
}


