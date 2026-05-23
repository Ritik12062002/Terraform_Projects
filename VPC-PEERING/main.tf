resource "aws_vpc" "primary_vpc" {
  provider = aws.primary
  cidr_block = var.primary_vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Primary VPC-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_vpc" "secondary_vpc" {
  provider = aws.secondary
  cidr_block = var.secondary_vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Secondary VPC-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_subnet" "primary_subnet" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  cidr_block = var.primary_vpc_cidr
  availability_zone = data.aws_availability_zones.primary_az.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Primary Subnet-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_subnet" "secondary_subnet" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id
  cidr_block = var.secondary_vpc_cidr
  availability_zone = data.aws_availability_zones.secondary_az.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Secondary Subnet-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  tags = {
    Name = "Primary IGW-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_internet_gateway" "secondary_igw" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id
  tags = {
    Name = "Secondary IGW-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_route_table" "primary_route_table" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }
  tags = {
    Name = "Primary Route Table-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

resource "aws_route_table" "secondary_route_table" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_vpc.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }
  tags = {
    Name = "Primary Route Table-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}


# Route Table Association Primary

resource "aws_route_table_association" "primary_route_table_association" {
  provider = aws.primary
  subnet_id = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_route_table.id
}

# Route Table Association Secondary

resource "aws_route_table_association" "secondary_route_table_association" {
  provider = aws.secondary
  subnet_id = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_route_table.id
}

# VPC Peering Request
resource "aws_vpc_peering_connection" "vpc_peering_request" {
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id
  peer_region = var.secondary_region
  peer_vpc_id = aws_vpc.secondary_vpc.id
  auto_accept = false
  
  tags = {
    Name = "VPC Peering Connection-${var.primary_region}-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}


resource "aws_vpc_peering_connection_accepter" "secondary_acceptor" {
  provider = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_request.id
  auto_accept = true
  tags = {
    Name = "VPC Peering Accepter-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

# Route Primary -> Secondary

resource "aws_route" "primary_to_secondary" {
  provider = aws.primary
  route_table_id = aws_route_table.primary_route_table.id
  destination_cidr_block = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_request.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_acceptor]
}

# Route Secondary -> Primary

resource "aws_route" "secondary_to_primary" {
  provider = aws.secondary
  route_table_id = aws_route_table.secondary_route_table.id
  destination_cidr_block = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_request.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_acceptor]
}



# Primary Security Group
resource "aws_security_group" "primary_sg" {
  provider = aws.primary
  name     = "primary-sg"
  vpc_id   = aws_vpc.primary_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Secondary Security Group
resource "aws_security_group" "secondary_sg" {
  provider = aws.secondary
  name     = "secondary-sg"
  vpc_id   = aws_vpc.secondary_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Primary Instance

resource "aws_instance" "primary_instance" {
  provider = aws.primary
  ami           = data.aws_ami.primary_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name = "primary-key"
  user_data = file("./primary.sh")
  tags = {
    Name = "Primary Instance-${var.primary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}

# Secondary Instance

resource "aws_instance" "secondary_instance" {
  provider = aws.secondary
  ami           = data.aws_ami.secondary_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name = "secondary-key"
  user_data = file("./secondary.sh")
  tags = {
    Name = "Secondary Instance-${var.secondary_region}"
    environment = "testing"
    owner = "Ritik"
  }
}