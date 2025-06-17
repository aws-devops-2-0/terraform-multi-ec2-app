# terraform-multi-ec2-app/instances.tf

# Load Balancer Instance (Nginx Reverse Proxy)
resource "aws_instance" "nginx_lb" {
  ami                         = var.ami_id
  instance_type               = var.instance_type_lb
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.lb_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.app_name}-Nginx-LB"
    Environment = "Dev"
  }

  # User data to install Nginx for Ubuntu
  user_data = <<-EOF
                #!/bin/bash
                apt update -y # Corrected for Ubuntu
                apt install -y nginx # Corrected for Ubuntu
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
                        server ${aws_instance.app_server[0].private_ip}:80; # Reference now matches "app_server"
                        server ${aws_instance.app_server[1].private_ip}:80; # Reference now matches "app_server"
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
  count                       = 2
  ami                         = var.ami_id
  instance_type               = var.instance_type_app
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.app_name}-AppServer-${count.index + 1}"
    Environment = "Dev"
  }
  # User data to install Apache for Ubuntu
  user_data = <<-EOF
              #!/bin/bash
              apt update -y # Corrected for Ubuntu
              apt install -y apache2 # Corrected for Ubuntu (Apache package name)
              systemctl start apache2 # Corrected for Ubuntu (Apache service name)
              systemctl enable apache2 # Corrected for Ubuntu (Apache service name)
              echo "<h1>Hello from App Server ${count.index + 1}!</h1>" > /var/www/html/index.html
              EOF
}
