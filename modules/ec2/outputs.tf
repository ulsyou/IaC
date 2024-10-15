output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_host_sg_id" {
  value = aws_security_group.bastion_host.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id  
}

