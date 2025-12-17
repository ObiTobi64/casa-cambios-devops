# 🏦 Proyecto DevOps - Sistema de Casa de Cambios

## 📋 Información General

**Proyecto:** Sistema de Gestión de Casas de Cambio  
**Equipo:** DevOps Casa Cambios  
**Fecha:** Diciembre 2025  
**Instancia EC2:** devops-casa-cambios (13.56.79.41)  

---

## 🏗️ Arquitectura del Sistema

### Stack Tecnológico

#### **Frontend**
- React + TypeScript + Vite
- Material-UI
- React Router
- Axios
- Leaflet (Mapas)
- Chart.js (Gráficos)

#### **Backend**
- Node.js + Express
- PostgreSQL
- JWT Authentication
- CORS

#### **Infraestructura**
- Docker + Docker Compose
- AWS EC2 (t3.small)
- Terraform (IaC)

#### **Observabilidad**
- **Prometheus:** Recolección de métricas
- **Node Exporter:** Métricas del EC2 (CPU, RAM, Disco)
- **cAdvisor:** Métricas de contenedores Docker
- **Loki:** Servidor de logs
- **Promtail:** Recolector de logs
- **Grafana:** Visualización de métricas y logs

#### **CI/CD**
- GitHub Actions
- Discord Webhooks (Notificaciones)
- Docker Build & Push
- Automated Deployment

---

## 📊 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                           USUARIOS                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                     AWS EC2 Instance                            │
│                  (13.56.79.41 - t3.small)                       │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Docker Compose Network                      │  │
│  │                                                          │  │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────┐  │  │
│  │  │   Frontend   │    │   Backend    │    │PostgreSQL│  │  │
│  │  │   (React)    │◄───┤   (Node.js)  │◄───┤    DB    │  │  │
│  │  │   Port: 80   │    │  Port: 3000  │    │Port: 5432│  │  │
│  │  └──────────────┘    └──────┬───────┘    └──────────┘  │  │
│  │                              │                          │  │
│  │  ┌────────────────────────────────────────────────────┐ │  │
│  │  │         Observability Stack                        │ │  │
│  │  │                                                    │ │  │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │ │  │
│  │  │  │Prometheus│  │  Loki    │  │   Grafana    │   │ │  │
│  │  │  │Port: 9090│  │Port: 3100│  │  Port: 3001  │   │ │  │
│  │  │  └─────▲────┘  └─────▲────┘  └──────────────┘   │ │  │
│  │  │        │             │                           │ │  │
│  │  │  ┌─────┴──────┬──────┴─────┐                    │ │  │
│  │  │  │Node Export.│  │ Promtail │                    │ │  │
│  │  │  │Port: 9100  │  │Port: 9080│                    │ │  │
│  │  │  └────────────┘  └──────────┘                    │ │  │
│  │  │                                                    │ │  │
│  │  │  ┌──────────┐                                     │ │  │
│  │  │  │ cAdvisor │                                     │ │  │
│  │  │  │Port: 8080│                                     │ │  │
│  │  │  └──────────┘                                     │ │  │
│  │  └────────────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                         ▲
                         │
┌────────────────────────┴────────────────────────────────────────┐
│                   GitHub Actions CI/CD                          │
│                                                                 │
│  Build → Test → Deploy → Discord Notification                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Flujo de CI/CD

```
Commit/Push (main)
    │
    ▼
GitHub Actions Trigger
    │
    ├─► Build Backend Docker Image
    │
    ├─► Build Frontend Docker Image
    │
    ├─► Upload Images as Artifacts
    │
    ▼
Deploy to EC2
    │
    ├─► SSH to EC2
    │
    ├─► Download Docker Images
    │
    ├─► docker-compose down
    │
    ├─► docker-compose up -d
    │
    ├─► Verify Deployment
    │
    ▼
Discord Notification
    │
    ├─► ✅ Success (with commit info)
    │
    └─► ❌ Failure (with error logs)
```

---

## 🚀 Instalación y Despliegue

### Prerrequisitos

1. **AWS Account** con credenciales configuradas
2. **Terraform** instalado
3. **Git** instalado
4. **Key Pair** de AWS (`devops-casa-cambios.pem`)

### Paso 1: Crear Infraestructura con Terraform

```bash
cd terraform

# Copiar variables de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars con tus valores
# IMPORTANTE: Cambiar allowed_ssh_cidr por tu IP

# Inicializar Terraform
terraform init

# Ver plan de ejecución
terraform plan

# Aplicar cambios
terraform apply

# Guardar outputs importantes
terraform output
```

### Paso 2: Configurar GitHub Secrets

En tu repositorio de GitHub, ve a **Settings → Secrets and variables → Actions** y agrega:

1. **EC2_SSH_KEY**: Contenido de tu archivo `.pem`
   ```bash
   cat devops-casa-cambios.pem
   # Copiar todo el contenido incluyendo:
   # -----BEGIN RSA PRIVATE KEY-----
   # ...
   # -----END RSA PRIVATE KEY-----
   ```

2. **DISCORD_WEBHOOK_URL**: URL del webhook de Discord
   - En Discord: Server Settings → Integrations → Webhooks → New Webhook
   - Copiar la URL del webhook

### Paso 3: Conectarse a EC2 y Preparar Ambiente

```bash
# Conectar por SSH
ssh -i devops-casa-cambios.pem ec2-user@13.56.79.41

# Verificar instalaciones
docker --version
docker-compose --version
git --version

# Clonar repositorio (primera vez)
git clone https://github.com/TU_USUARIO/TU_REPO.git
cd TU_REPO

# Crear archivo .env
cp .env.example .env
nano .env
```

### Paso 4: Despliegue Manual (Primera Vez)

```bash
# Construir y levantar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Verificar estado
docker-compose ps
```

### Paso 5: Configurar CI/CD

```bash
# Hacer un commit en la rama main/master
git add .
git commit -m "Initial deployment"
git push origin main

# El pipeline se ejecutará automáticamente
# Recibirás notificación en Discord
```

---

## 📊 Acceso a Servicios

Una vez desplegado, accede a:

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **Frontend** | http://13.56.79.41 | - |
| **Backend API** | http://13.56.79.41:3000 | - |
| **Grafana** | http://13.56.79.41:3001 | admin / admin123 |
| **Prometheus** | http://13.56.79.41:9090 | - |
| **Node Exporter** | http://13.56.79.41:9100 | - |
| **cAdvisor** | http://13.56.79.41:8080 | - |

---

## 📈 Configuración de Grafana

### Primera Configuración

1. Accede a Grafana: http://13.56.79.41:3001
2. Login: `admin` / `admin123`
3. Los datasources ya están configurados automáticamente:
   - Prometheus (métricas)
   - Loki (logs)

### Dashboards Disponibles

#### 1. **EC2 Infrastructure Monitoring**
- CPU Usage del EC2
- Memory Usage del EC2
- Disk Usage del EC2
- Network Traffic
- System Uptime

#### 2. **Application Logs Dashboard**
- Logs del Backend
- Logs del Frontend
- Error Logs (todos los servicios)
- Log Volume por servicio

### Importar Dashboards Adicionales (Opcional)

Puedes importar dashboards de la comunidad:

1. En Grafana: Dashboards → Import
2. IDs recomendados:
   - **1860**: Node Exporter Full
   - **14282**: Docker Container & Host Metrics
   - **13639**: Docker Monitoring

---

## 🔍 Monitoreo y Métricas

### Métricas de Infraestructura (Prometheus)

#### CPU Usage
```promql
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

#### Memory Usage
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

#### Disk Usage
```promql
100 - ((node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} * 100) / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"})
```

### Consultas de Logs (Loki)

#### Logs del Backend
```logql
{service="backend"}
```

#### Logs con Errores
```logql
{level="error"}
```

#### Logs del Frontend
```logql
{service="frontend"}
```

---

## 🛠️ Comandos Útiles

### Docker Compose

```bash
# Levantar servicios
docker-compose up -d

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend

# Detener servicios
docker-compose down

# Reiniciar un servicio
docker-compose restart backend

# Ver estado
docker-compose ps

# Reconstruir imágenes
docker-compose build

# Limpiar contenedores detenidos
docker-compose down --remove-orphans
```

### Docker

```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores
docker ps -a

# Ver imágenes
docker images

# Limpiar imágenes no usadas
docker image prune -f

# Ver uso de recursos
docker stats

# Entrar a un contenedor
docker exec -it casa-cambios-backend sh
```

### Terraform

```bash
# Ver estado actual
terraform show

# Destruir infraestructura
terraform destroy

# Actualizar infraestructura
terraform apply

# Ver outputs
terraform output
```

---

## 🐛 Troubleshooting

### Problema: Contenedores no inician

```bash
# Ver logs detallados
docker-compose logs

# Revisar estado
docker-compose ps

# Reiniciar todo
docker-compose down
docker-compose up -d
```

### Problema: Grafana no muestra datos

```bash
# Verificar que Prometheus esté corriendo
curl http://localhost:9090/-/healthy

# Verificar que Loki esté corriendo
curl http://localhost:3100/ready

# Reiniciar Grafana
docker-compose restart grafana
```

### Problema: EC2 sin memoria

```bash
# Ver uso de memoria
free -h

# Ver swap
swapon --show

# Ver procesos que consumen memoria
top
# Presionar Shift+M para ordenar por memoria

# Si es necesario, reiniciar contenedores
docker-compose restart
```

### Problema: Pipeline falla en GitHub Actions

1. Revisar logs en GitHub Actions
2. Verificar secretos:
   - `EC2_SSH_KEY` debe tener el contenido completo del .pem
   - `DISCORD_WEBHOOK_URL` debe ser una URL válida
3. Verificar conectividad SSH al EC2
4. Verificar Security Group permite SSH (puerto 22)

---

## 📝 Checklist de Entrega

### ✅ Repositorio Git
- [ ] Código fuente (Frontend + Backend)
- [ ] Dockerfiles
- [ ] docker-compose.yml
- [ ] Configuración de monitoreo (/monitoring)
- [ ] GitHub Actions workflow
- [ ] Terraform files
- [ ] README.md

### ✅ Instancia EC2
- [ ] Instancia activa y accesible
- [ ] Security Groups configurados
- [ ] Todos los servicios corriendo
- [ ] Puertos accesibles (80, 3000, 3001, 9090)

### ✅ Observabilidad
- [ ] Grafana funcionando
- [ ] Dashboard de métricas EC2 visible
- [ ] Dashboard de logs visible
- [ ] Prometheus recolectando métricas
- [ ] Loki recolectando logs

### ✅ CI/CD
- [ ] Pipeline de GitHub Actions funcional
- [ ] Notificaciones a Discord funcionando
- [ ] Build automático
- [ ] Deploy automático

### ✅ Infraestructura como Código
- [ ] Terraform files completos
- [ ] terraform.tfvars configurado
- [ ] Infraestructura creada con Terraform

### ✅ Documentación
- [ ] Diagrama de arquitectura
- [ ] Capturas de pantalla:
  - [ ] Dashboard Grafana con métricas CPU/RAM
  - [ ] Panel de Logs en Grafana
  - [ ] Notificación en Discord
- [ ] Informe técnico

---

## 👥 Equipo

- **Nombre del equipo:** [TU EQUIPO]
- **Integrantes:**
  - [Nombre 1]
  - [Nombre 2]
  - [Nombre 3]

---

## 📄 Licencia

Este proyecto es parte del 3er Parcial de DevOps - UPB 2025

---

## 🔗 Enlaces Útiles

- [Documentación Docker](https://docs.docker.com/)
- [Documentación Docker Compose](https://docs.docker.com/compose/)
- [Documentación Terraform](https://www.terraform.io/docs)
- [Documentación Prometheus](https://prometheus.io/docs/)
- [Documentación Grafana](https://grafana.com/docs/)
- [Documentación Loki](https://grafana.com/docs/loki/)
- [GitHub Actions](https://docs.github.com/en/actions)
