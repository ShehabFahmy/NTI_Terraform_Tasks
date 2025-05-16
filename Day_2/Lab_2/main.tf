resource "aws_instance" "ec2-instance" {
  ami = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  subnet_id = "subnet-0eb073fc1b10df568"
  vpc_security_group_ids = ["sg-002bd45524ee7ec36"]
  key_name = "my-rsa-key"

  tags = {
    "Name" = "nti-day2"
    "New_Tag" = "nti-day2-task4"
  }
}