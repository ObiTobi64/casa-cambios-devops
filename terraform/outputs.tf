output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.casa_cambios_ec2.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_eip.casa_cambios_eip.public_ip
}

output "instance_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.casa_cambios_ec2.public_dns
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.casa_cambios_sg.id
}

output "frontend_url" {
  description = "URL del Frontend"
  value       = "http://${aws_eip.casa_cambios_eip.public_ip}"
}

output "backend_url" {
  description = "URL del Backend"
  value       = "http://${aws_eip.casa_cambios_eip.public_ip}:3000"
}

output "grafana_url" {
  description = "URL de Grafana"
  value       = "http://${aws_eip.casa_cambios_eip.public_ip}:3001"
}

output "prometheus_url" {
  description = "URL de Prometheus"
  value       = "http://${aws_eip.casa_cambios_eip.public_ip}:9090"
}

output "ssh_command" {
  description = "Comando SSH para conectarse a la instancia"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_eip.casa_cambios_eip.public_ip}"
}
