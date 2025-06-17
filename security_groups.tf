# terraform-multi-ec2-app/security_groups.tf

resource "aws_security_groups" "lb_sg" {
  name        = "${var.app_name}-LB-SG"
  description = "Allow HTTP/HTTPS from internet, SSH for admin"
  vpc_id      = aws_vpc.app_vpc.id

  # Allow HTTP traffic (from anywhere for demo)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  # Allow SSH for administration (from anywhere for demo)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access for administration"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "${var.app_name}-LB-SG"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-App-SG"
  description = "Allow HTTP from LB, SSH for admin"
  vpc_id      = aws_vpc.app_vpc.id

  # Allow HTTP traffic *only from* the Load Balancer Security Group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Source is the LB's SG
    description     = "Allow HTTP from LB"
  }

  # Allow SSH for administration (from anywhere for demo)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH inbound"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-App-SG"
  }
}
