output "public_ip" {
  value = aws_instance.cal_com.public_dns
}

# output "ssh_command" {
#   value = "ssh -i \"${var.private_key_file_path}\" ec2-user@${aws_instance.cal_com.public_dns}"
# }

output "security_group" {
  value = aws_security_group.cal_sg.arn
}

output "instance_name" {
  value = aws_instance.cal_com.tags.Name
}

output "security_group_name" {
  value = aws_security_group.cal_sg.name
}