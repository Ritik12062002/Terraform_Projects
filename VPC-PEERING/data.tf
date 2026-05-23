# Primary Availability Zone
data "aws_availability_zones" "primary_az" {
  provider = aws.primary
  state    = "available"
}

# Secondary Availability Zone
data "aws_availability_zones" "secondary_az" {
  provider = aws.secondary
  state    = "available"
}


# Amazon Linux AMI Primary
data "aws_ami" "primary_ami" {
  provider    = aws.primary
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Amazon Linux AMI Secondary
data "aws_ami" "secondary_ami" {
  provider    = aws.secondary
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}