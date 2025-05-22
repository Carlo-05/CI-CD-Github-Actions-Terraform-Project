output "webapp_instance_id" {
    value = aws_instance.WebApp.id  
}

output "webapp_instance_public_ip" {
    value = aws_instance.WebApp.public_ip  
}

output "webapp_instance_private_ip" {
    value = aws_instance.WebApp.private_ip
}