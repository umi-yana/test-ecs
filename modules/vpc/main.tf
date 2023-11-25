# VPCの作成
resource "aws_vpc" "production-vpc" {
  cidr_block = "10.0.0.0/16"
}

#Public Subnet #1
resource "aws_subnet" "public-subnet-1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1a"
}

#Private Subnet #1(今後マルチAZ化する可能性があるため（最大AZ X３）　cidr_blockは開けて用意する)
resource "aws_subnet" "private-subnet-1" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-northeast-1a"
}

#Internet Gateway
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id
}

#Create a route table 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id
}

# route table と　IGWを紐付け
resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#Associate the routing table to the public subnet
resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}


#Create a route table 
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id
}

#Associate the routing table to the private subnet
resource "aws_route_table_association" "private-subnet-1-assocaiation" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

#Create Elastic ip
resource "aws_eip" "elastic-ip-for-nat-gw" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.production-igw]
}

#Create a nat gateway and place it into public subnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id


  depends_on = [aws_eip.elastic-ip-for-nat-gw]

}

#Add route to nat gateway in private subnet
resource "aws_route" "nat_gw_route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}