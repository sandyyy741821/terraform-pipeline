output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "public_dns" {
  value = aws_instance.web_server.public_dns
}

output "security_group" {
  value = aws_security_group.web_sg.arn
}

output "instance_name" {
  value = aws_instance.web_server.tags.Name
}

output "security_group_name" {
  value = aws_security_group.web_sg.name
}