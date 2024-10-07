
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "templatevpc"
  }
}

resource "aws_subnet" "public" {
  count = var.create_public_subnet ? length(var.public_subnet_cidrs) : 0  # Create a public subnet for each CIDR

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)  # Use the CIDR block for the current index
  availability_zone = var.availability_zones[count.index]  # Use the corresponding AZ

  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"  # Unique name for each subnet
  }
}

resource "aws_subnet" "private" {
  count = var.create_private_subnet ? length(var.private_subnet_cidrs) : 0  # Create a private subnet for each CIDR

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)  # Use the CIDR block for the current index
  availability_zone = var.availability_zones[count.index]  # Use the corresponding AZ

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"  # Unique name for each subnet
  }
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_nat_gateway" "this" {
  count = var.create_private_with_internet_access ? 1 : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element([for k, v in aws_subnet.public : v.id], 0)  # Accessing public subnet ID

  tags = {
    Name = "NATGateway"
  }
}



resource "aws_eip" "nat" {
  count = var.create_private_with_internet_access ? 1 : 0
}

resource "aws_route_table" "private" {
  count = var.create_private_with_internet_access ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private" {
  count = var.create_private_with_internet_access ? length(aws_subnet.private) : 0

  subnet_id      = aws_subnet.private[count.index].id  # Use the ID from the private subnet
  route_table_id = aws_route_table.private[0].id       # Reference the first private route table
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)  # Create an association for each public subnet

  subnet_id      = aws_subnet.public[count.index].id  # Use the ID from the public subnet
  route_table_id = aws_route_table.public.id            # Reference the public route table
}
