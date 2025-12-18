# 🚀 Guía de Despliegue Paso a Paso

Esta guía te llevará desde cero hasta tener tu aplicación completamente desplegada y monitoreada en AWS.

## 📋 Prerrequisitos

Antes de comenzar, asegúrate de tener:

- [ ] Cuenta de AWS activa
- [ ] AWS CLI instalado y configurado
- [ ] Terraform instalado (v1.0 o superior)
- [ ] Git instalado
- [ ] Archivo de clave SSH de AWS (`.pem`)
- [ ] Cuenta de Discord o Slack

---

## Fase 1: Configuración de Infraestructura con Terraform

### Paso 1.1: Configurar AWS CLI

```bash
# Configurar credenciales de AWS
aws configure

# Ingresar:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region: us-west-1
# - Default output format: json

# Verificar configuración
aws sts get-caller-identity
```

### Paso 1.2: Preparar Terraform

```bash
# Navegar al directorio de Terraform
cd terraform

# Copiar archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars
# IMPORTANTE: Cambiar los siguientes valores:
nano terraform.tfvars
```

Edita estos valores en `terraform.tfvars`:
```hcl
aws_region = "us-west-1"  # Tu región
project_name = "devops-casa-cambios"
instance_type = "t3.small"  # Recomendado para Grafana/Prometheus
key_name = "devops-casa-cambios"  # Nombre de tu key pair en AWS

# CRÍTICO: Cambiar por tu IP para seguridad
allowed_ssh_cidr = ["TU_IP_PUBLICA/32"]  # Ejemplo: ["201.123.45.67/32"]
```

### Paso 1.3: Crear Infraestructura

```bash
# Inicializar Terraform
terraform init

# Ver el plan de ejecución (qué se va a crear)
terraform plan

# Aplicar cambios (crear infraestructura)
terraform apply
# Escribe 'yes' cuando te lo pida

# IMPORTANTE: Guardar los outputs
terraform output > ../outputs.txt
```

### Paso 1.4: Guardar Información Importante

```bash
# Ver la IP pública de tu EC2
terraform output instance_public_ip

# Guardar en un archivo para referencia
cat > ../INSTANCE_INFO.txt << EOF
EC2 Public IP: $(terraform output -raw instance_public_ip)
Frontend URL: $(terraform output -raw frontend_url)
Backend URL: $(terraform output -raw backend_url)
Grafana URL: $(terraform output -raw grafana_url)
Prometheus URL: $(terraform output -raw prometheus_url)
SSH Command: $(terraform output -raw ssh_command)
EOF

cat ../INSTANCE_INFO.txt
```

---

## Fase 2: Configurar EC2

### Paso 2.1: Conectarse a EC2

```bash
# Asegurar permisos correctos en el archivo .pem
chmod 400 devops-casa-cambios.pem

# Conectarse por SSH (usar la IP de terraform output)
ssh -i devops-casa-cambios.pem ec2-user@TU_IP_PUBLICA

# Si da error "Connection timed out", verifica:
# 1. Security Group permite SSH (puerto 22)
# 2. Tu IP está en allowed_ssh_cidr
# 3. La instancia EC2 está corriendo
```

### Paso 2.2: Verificar Instalaciones

Una vez dentro del EC2:

```bash
# Verificar Docker
docker --version
docker ps

# Verificar Docker Compose
docker-compose --version

# Verificar Git
git --version

# Verificar Swap (para evitar problemas de memoria)
free -h
swapon --show
```

### Paso 2.3: Clonar Repositorio

```bash
# Clonar tu repositorio
git clone https://github.com/TU_USUARIO/TU_REPO.git
cd TU_REPO

# Si el repo es privado, necesitarás configurar SSH o usar token:
# Opción 1: Con token
git clone https://TU_TOKEN@github.com/TU_USUARIO/TU_REPO.git

# Opción 2: Configurar SSH (recomendado)
# Genera una clave SSH en el EC2 y agrégala a GitHub
ssh-keygen -t ed25519 -C "ec2-deployment"
cat ~/.ssh/id_ed25519.pub
# Copia la clave y agrégala en GitHub → Settings → SSH Keys
```

### Paso 2.4: Configurar Variables de Entorno

```bash
# Crear archivo .env
cat > .env << 'EOF'
DB_USER=postgres
DB_PASSWORD=postgres123
DB_NAME=casacambios
GRAFANA_USER=admin
GRAFANA_PASSWORD=admin123
EOF

# Verificar
cat .env
```

---

## Fase 3: Primer Despliegue Manual

### Paso 3.1: Construir y Levantar Servicios

```bash
# Construir las imágenes (primera vez tarda más)
docker-compose build

# Levantar todos los servicios
docker-compose up -d

# Ver el progreso
docker-compose logs -f

# Presiona Ctrl+C para dejar de ver los logs
```

### Paso 3.2: Verificar que Todo Esté Corriendo

```bash
# Ver estado de contenedores
docker-compose ps

# Deberías ver todos los servicios en estado "Up":
# - postgres
# - backend
# - frontend
# - prometheus
# - node-exporter
# - cadvisor
# - loki
# - promtail
# - grafana

# Ver uso de recursos
docker stats --no-stream
```

### Paso 3.3: Probar los Servicios

En tu navegador local, accede a:

1. **Frontend:** http://TU_IP_PUBLICA
   - Debería cargar la aplicación React

2. **Backend API:** http://TU_IP_PUBLICA:3000
   - Debería responder (puede ser un error si no hay ruta raíz, es normal)

3. **Grafana:** http://TU_IP_PUBLICA:3001
   - Login: admin / admin123

4. **Prometheus:** http://TU_IP_PUBLICA:9090
   - Debería cargar la interfaz de Prometheus

Si alguno no funciona, verifica:
```bash
# Ver logs de un servicio específico
docker-compose logs backend
docker-compose logs frontend
docker-compose logs grafana
```

---

## Fase 4: Configurar Grafana

### Paso 4.1: Acceder a Grafana

1. Navega a: http://TU_IP_PUBLICA:3001
2. Login: `admin` / `admin123`
3. (Opcional) Cambia la contraseña cuando te lo pida

### Paso 4.2: Verificar Datasources

1. Sidebar → Configuration (⚙️) → Data sources
2. Deberías ver:
   - **Prometheus** (default)
   - **Loki**
3. Ambos deben tener un check verde ✅

### Paso 4.3: Verificar Dashboards

1. Sidebar → Dashboards → Browse
2. Deberías ver:
   - **EC2 Infrastructure Monitoring**
   - **Application Logs Dashboard**
3. Click en cada uno para verificar que muestran datos

### Paso 4.4: Tomar Capturas de Pantalla

**IMPORTANTE para la entrega:**

1. Dashboard de Infraestructura:
   - Abre "EC2 Infrastructure Monitoring"
   - Espera a que carguen los gráficos
   - Captura de pantalla mostrando CPU, RAM, Disco

2. Dashboard de Logs:
   - Abre "Application Logs Dashboard"
   - Captura de pantalla mostrando logs del backend/frontend

---

## Fase 5: Configurar CI/CD con GitHub Actions

### Paso 5.1: Configurar Webhook de Discord

1. En Discord:
   - Server Settings → Integrations → Webhooks
   - New Webhook → Nombrar "Casa Cambios CI/CD"
   - Copy Webhook URL
   - Guardar la URL

### Paso 5.2: Configurar GitHub Secrets

1. En GitHub → Tu repositorio → Settings → Secrets and variables → Actions

2. Agregar `EC2_SSH_KEY`:
   ```bash
   # En tu máquina local
   cat devops-casa-cambios.pem
   ```
   - Copiar TODO el contenido
   - New repository secret
   - Name: `EC2_SSH_KEY`
   - Value: Pegar el contenido completo
   - Add secret

3. Agregar `DISCORD_WEBHOOK_URL`:
   - New repository secret
   - Name: `DISCORD_WEBHOOK_URL`
   - Value: Pegar la URL del webhook de Discord
   - Add secret

### Paso 5.3: Actualizar IP en GitHub Actions

Edita el archivo `.github/workflows/deploy.yml`:

```yaml
env:
  EC2_HOST: TU_IP_PUBLICA  # Cambiar por tu IP
  EC2_USER: ec2-user
```

### Paso 5.4: Probar el Pipeline

```bash
# En tu máquina local
git add .
git commit -m "feat: Configure CI/CD pipeline"
git push origin main

# El pipeline se ejecutará automáticamente
# Verifica en GitHub → Actions
# Deberías recibir notificación en Discord
```

---

## Fase 6: Verificación Final

### Checklist de Verificación

En el EC2:
```bash
# Conectarse al EC2
ssh -i devops-casa-cambios.pem ec2-user@TU_IP_PUBLICA

# Verificar todos los servicios
docker-compose ps

# Verificar logs
docker-compose logs --tail=50

# Verificar uso de recursos
docker stats --no-stream
free -h
df -h
```

En tu navegador:
- [ ] Frontend carga correctamente
- [ ] Backend responde (prueba login/register)
- [ ] Grafana muestra dashboards con datos
- [ ] Prometheus muestra métricas
- [ ] Todos los contenedores están "Up"

CI/CD:
- [ ] Pipeline se ejecutó exitosamente
- [ ] Recibiste notificación en Discord
- [ ] El despliegue fue automático

---

## 📸 Capturas Requeridas para Entrega

1. **Dashboard de Grafana - Infraestructura:**
   - CPU Usage con datos
   - Memory Usage con datos
   - Disk Usage con datos
   - Panel completo visible

2. **Dashboard de Grafana - Logs:**
   - Backend logs visibles
   - Frontend logs visibles
   - Timestamp actual

3. **Notificación de Discord:**
   - Mensaje de despliegue exitoso
   - Mostrando commit SHA
   - Mostrando autor
   - Mostrando URLs

4. **Terminal mostrando:**
   ```bash
   docker-compose ps
   # Todos los servicios en "Up"
   ```

5. **Terraform outputs:**
   ```bash
   terraform output
   ```

---

## 🐛 Problemas Comunes

### Problema 1: EC2 sin memoria

**Síntoma:** Servicios se caen, docker-compose no responde

**Solución:**
```bash
# Ver memoria
free -h

# Si no hay swap, crear:
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Reiniciar servicios
docker-compose restart
```

### Problema 2: Puerto ya en uso

**Síntoma:** Error "port is already allocated"

**Solución:**
```bash
# Ver qué está usando el puerto
sudo netstat -tulpn | grep :3000

# Detener el proceso o cambiar puerto en docker-compose.yml
sudo kill -9 PID_DEL_PROCESO

# Reiniciar
docker-compose down
docker-compose up -d
```

### Problema 3: Grafana no muestra datos

**Síntoma:** Dashboards vacíos

**Solución:**
```bash
# Verificar Prometheus
curl http://localhost:9090/-/healthy

# Verificar Loki
curl http://localhost:3100/ready

# Reiniciar Grafana
docker-compose restart grafana

# Esperar 1-2 minutos para que recolecte datos
```

### Problema 4: Pipeline falla en SSH

**Síntoma:** "Permission denied (publickey)"

**Solución:**
1. Verificar que `EC2_SSH_KEY` en GitHub tiene el contenido completo del .pem
2. Verificar Security Group permite SSH desde GitHub Actions (0.0.0.0/0)
3. Verificar que la IP en `deploy.yml` es correcta

---

