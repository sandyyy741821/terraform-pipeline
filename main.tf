#####################################
# Generate SSH Key
#####################################

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/terraform-ec2-key.pem"
}

#####################################
# VPC
#####################################

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

#####################################
# Internet Gateway
#####################################

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

#####################################
# Public Subnet
#####################################

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet"
  }
}

#####################################
# Route Table
#####################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.main_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

#####################################
# Security Group
#####################################

resource "aws_security_group" "web_sg" {
  name   = var.security_group_name
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = "custom rule"
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################
# EC2 INSTANCE
#####################################

resource "aws_instance" "web_server" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  key_name = aws_key_pair.ec2_keypair.key_name

  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}