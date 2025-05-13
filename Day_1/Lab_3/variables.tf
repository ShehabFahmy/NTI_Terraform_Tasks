variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc-cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet-cidr" {
  type    = tuple([string, string])
  default = ["Public-Subnet", "10.0.1.0/24"]
}

variable "aws-linux-instance-ami" {
  type = string
  default = "ami-0f88e80871fd81e91"
}

variable "instance-type" {
  type = string
  default = "t2.micro"
}

variable "nginx-installation" {
  type = string
  default = <<-EOF
            #!/bin/bash
            sudo dnf install -y nginx
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "Hello from Terraform!" > /usr/share/nginx/html/index.html
            EOF
}