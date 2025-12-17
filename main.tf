# Generate Private key
resource "tls_private_key" "test_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# upload public to aws
resource "aws_key_pair" "public_key" {
  key_name   = var.key_name
  public_key = tls_private_key.test_key.public_key_openssh
}

# Create a local file for the private key
resource "local_sensitive_file" "private_key" {
  filename        = var.private_key_file_path
  content         = tls_private_key.test_key.private_key_pem
  file_permission = 0600
}


resource "aws_instance" "cal_com" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.cal_sg.id]
  key_name                    = aws_key_pair.public_key.key_name
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "cal_sg" {
  name   = var.security_group_name
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
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