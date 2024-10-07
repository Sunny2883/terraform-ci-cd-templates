output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids_output" {
  value = [for subnet in aws_subnet.public : subnet.id]  # Return a list of public subnet IDs
}

output "private_subnet_ids_output" {
  value = [for subnet in aws_subnet.private : subnet.id]  # Return a list of private subnet IDs
}

output "private_internet_subnet_ids" {
  value = [for nat in aws_nat_gateway.this : nat.id]  # Return a list of NAT Gateway IDs
}
