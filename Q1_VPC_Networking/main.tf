terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# ----------------------------
# 1. VPC
# ----------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Utkarsh_Mishra_VPC"
  }
}

# ----------------------------
# 2. PUBLIC SUBNETS
# ----------------------------
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Utkarsh_Mishra_Public_Subnet_1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Utkarsh_Mishra_Public_Subnet_2"
  }
}

# ----------------------------
# 3. PRIVATE SUBNETS
# ----------------------------
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Utkarsh_Mishra_Private_Subnet_1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Utkarsh_Mishra_Private_Subnet_2"
  }
}

# ----------------------------
# 4. INTERNET GATEWAY
# ----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Utkarsh_Mishra_IGW"
  }
}

# ----------------------------
# 5. PUBLIC ROUTE TABLE
# ----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Utkarsh_Mishra_Public_Route_Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

# ----------------------------
# 6. NAT GATEWAY (Requires EIP)
# ----------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "Utkarsh_Mishra_NAT_EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id  # NAT MUST be in public subnet

  tags = {
    Name = "Utkarsh_Mishra_NAT_Gateway"
  }
}

# ----------------------------
# 7. PRIVATE ROUTE TABLE
# ----------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Utkarsh_Mishra_Private_Route_Table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}
 
