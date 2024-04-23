output "ec2-instances" {
  value = aws_instance.instance[*]
}
