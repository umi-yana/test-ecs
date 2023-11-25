# VPCの作成
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# サブネットの作成
resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

# Internet Gatewayの作成
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# NAT Gatewayの作成
resource "aws_eip" "example" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id
  depends_on    = [aws_eip.example]
}

# ルートテーブルの作成
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

# セキュリティグループの作成
resource "aws_security_group" "example" {
  name   = "${var.default_name}_security_group"
  vpc_id = aws_vpc.example.id
}
