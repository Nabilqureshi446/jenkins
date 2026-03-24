provider "aws" {
  region = "us-east-1"   
}

# Key Pair (optional if you already have one)
resource "aws_key_pair" "deployer" {
  key_name   = "3tier"
  public_key = file("C:/Users/hp/Downloads/id_rsa.pub")
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-0ec10929233384c7f"  # Amazon Linux 2 (ap-south-1)
  instance_type = "t3.small"
  key_name      = aws_key_pair.deployer.key_name

  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name = "MyTerraformEC2"
  }
}