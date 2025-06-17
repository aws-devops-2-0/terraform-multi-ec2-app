# terraform-multi-ec2-app/instances.tf

# Load Balancer Instance (Nginx Reverse Proxy)
resource "aws_instance" "nginx_lb" {
  ami                         = var.ami_id
  instance_type               = var.instance_type_lb
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.lb_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.app_name}-Nginx-LB"
    Environment = "Dev"
  }

  # User data to install Nginx and configure a basic reverse proxy
  # This will need to be updated with actual app server IPs for a real scenario

  user_data = <<-EOF
                #!/bin/bash
                apt update -y # Use yum for Amazon Linux
                apt install -y nginx # Use yum for Amazon Linux
                systemctl start nginx
                systemctl enable nginx

                # Basic Nginx reverse proxy configuration
                echo "
                worker_processes 1;
                events {
                    worker_connections 1024;
                }

                http {
                    upstream app_servers {
                        server ${aws_instance.app_server[0].private_ip}:80; # Reference first app server
                        server ${aws_instance.app_server[1].private_ip}:80; # Reference second app server
                    }
                    server {
                        listen 80;
                        location / {
                            proxy_pass http://app_servers;
                        }
                    }
                }
                " > /etc/nginx/nginx.conf

                systemctl restart nginx
              EOF
}

resource "aws_instance" "app_server" {
  count                       = 2 # <--- This creates 2 instances!
  ami                         = var.ami_id
  instance_type               = var.instance_type_app
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id # Still in public subnet for SSH access
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true # Assign public IPs for individual SSH access

  tags = {
    Name        = "${var.app_name}-AppServer-${count.index + 1}" # Unique name for each instance
    Environment = "Dev"
  }
  # User data to install Apache and set a simple response
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from App Server ${count.index + 1}!</h1>" > /var/www/html/index.html
              EOF


}
