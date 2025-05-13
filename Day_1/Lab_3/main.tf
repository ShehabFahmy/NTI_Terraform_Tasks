resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "App-VPC",
  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.subnet-cidr[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-cidr[0],
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  
  tags = {
    Name = "App-IGW"
  }
}

resource "aws_route_table" "my-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  
  tags = {
    Name = "App-RTB"
  }
}

resource "aws_route_table_association" "my-rtb-assoc" {
  subnet_id = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-rtb.id
}

resource "aws_security_group" "my-instance-secgrp" {
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_instance" "aws-linux-instance" {
  ami = var.aws-linux-instance-ami
  instance_type = var.instance-type
  key_name = "my-rsa-key"
  subnet_id = aws_subnet.my-subnet.id
  vpc_security_group_ids = [aws_security_group.my-instance-secgrp.id]
  user_data = var.nginx-installation
  associate_public_ip_address = true

  tags = {
    Name = "Web-Server"
  }
}