output "primary_public_ip" {
  value = aws_instance.primary_instance.public_ip
}

output "secondary_public_ip" {
  value = aws_instance.secondary_instance.public_ip
}

