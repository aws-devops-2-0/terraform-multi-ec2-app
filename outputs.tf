# terraform-multi-ec2-app/outputs.tf
output "nginx_lb_public_ip" {
  description = "The public IP address of the Nginx Load Balancer"
  value       = aws_instance.nginx_lb.public_ip
}

output "nginx_lb_public_dns" {
  description = "The public DNS name of the Nginx Load Balancer"
  value       = aws_instance.nginx_lb.public_dns
}

output "app_server_public_ips" {
  description = "List of public IP addresses of the application servers"
  value       = aws_instance.app_server[*].public_ip
}

output "app_server_private_ips" {
  description = "List of private IP addresses of the application servers"
  value       = aws_instance.app_server[*].private_ip
}
