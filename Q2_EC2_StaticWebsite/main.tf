provider "aws" {
  region = "ap-south-1"
}

# --------------------------
# SECURITY GROUP FOR EC2
# --------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "Utkarsh_Mishra_EC2_SG"
  vpc_id = var.vpc_id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from your system only (best practice)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"]   # replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Utkarsh_Mishra_EC2_SG"
  }
}

# --------------------------
# EC2 INSTANCE
# --------------------------
resource "aws_instance" "web" {
  ami                    = "ami-0f5ee92e2d63afc18"   # Amazon Linux 2 free tier
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              
              echo "<h1>Resume Website - Hosted by Utkarsh Mishra</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Utkarsh_Mishra_EC2_WebServer"
  }
}

# --------------------------
# VARIABLES (VPC + SUBNET)
# --------------------------
variable "vpc_id" {}
variable "public_subnet_id" {}
 
