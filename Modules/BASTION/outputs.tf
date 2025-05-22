output "bastion_ip" {
    value = aws_instance.BastionHost.public_ip
  
}

