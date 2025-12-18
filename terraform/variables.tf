variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "devops-casa-cambios"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.small" # t3.small para evitar problemas de memoria con Grafana/Prometheus
}

variable "key_name" {
  description = "Nombre del key pair para SSH"
  type        = string
  default     = "devops-casa-cambios"
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH (tu IP pública)"
  type        = list(string)
  default     = ["0.0.0.0/0"] # CAMBIAR por tu IP específica para mayor seguridad
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "production"
}

variable "volume_size" {
  description = "Tamaño del volumen EBS en GB"
  type        = number
  default     = 20
}
