output "ec2-ip" {
  value       = aws_instance.aws-linux-instance.public_ip
  description = "The public IP of the web server."
}