# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Use a subnet from the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "secgrp" {
  vpc_id = data.aws_vpc.default.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-instance-secgrp"
  }
}

resource "aws_instance" "ec2" {
  ami                    = "ami-0f88e80871fd81e91"
  instance_type          = "t2.micro"
  key_name               = "my-rsa-key"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.secgrp.id]
  user_data = <<-EOF
            #!/bin/bash
            sudo dnf install nginx -y
            echo "Hello From EC2 Instance!" | sudo tee /usr/share/nginx/html/index.html
            sudo systemctl start nginx
            EOF
  associate_public_ip_address = true

  tags = {
    Name = "public-ec2"
  }
}
