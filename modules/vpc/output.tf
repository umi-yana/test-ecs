output "private-subnet-1" {
  value = aws_subnet.private-subnet-1.id
}

output "vpc_id" {
  value = aws_vpc.production-vpc.id
}