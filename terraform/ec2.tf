# Obtener la AMI más reciente de Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

# Security Group para la instancia EC2
resource "aws_security_group" "casa_cambios_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group para Casa de Cambios DevOps"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # HTTP - Frontend
  ingress {
    description = "HTTP - Frontend"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS 
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend API
  ingress {
    description = "Backend API"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    description = "Grafana"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node Exporter
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # cAdvisor
  ingress {
    description = "cAdvisor"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress - Permitir todo el tráfico saliente
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Instancia EC2
resource "aws_instance" "casa_cambios_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.casa_cambios_sg.id]

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  # Script de inicialización
  user_data = <<-EOF
              #!/bin/bash
              # Actualizar el sistema
              yum update -y
              
              # Instalar Docker
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Agregar el usuario ec2-user al grupo docker
              usermod -aG docker ec2-user
              
              # Instalar Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
              
              # Instalar Git
              yum install -y git
              
              # Crear swap para evitar problemas de memoria (4GB)
              dd if=/dev/zero of=/swapfile bs=1M count=4096
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab
              
              # Configurar límites de memoria del sistema
              echo "vm.swappiness=10" >> /etc/sysctl.conf
              sysctl -p
              
              # Crear directorio para el proyecto
              mkdir -p /home/ec2-user/casa-cambios
              chown ec2-user:ec2-user /home/ec2-user/casa-cambios
              
              echo "EC2 Instance initialized successfully" > /home/ec2-user/init-complete.txt
              EOF

  tags = {
    Name        = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Casa de Cambios DevOps"
  }
}

# IP Elástica (opcional pero recomendado)
resource "aws_eip" "casa_cambios_eip" {
  instance = aws_instance.casa_cambios_ec2.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
