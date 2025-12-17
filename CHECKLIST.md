# 📋 Checklist de Proyecto DevOps - 3er Parcial

## ✅ Tareas Completadas

### 1. Infraestructura y Contenerización ✅

- [x] **Docker Compose** completo con todos los servicios:
  - [x] Frontend (React + Vite)
  - [x] Backend (Node.js + Express)
  - [x] PostgreSQL (Base de datos)
  - [x] Prometheus (Métricas)
  - [x] Node Exporter (Métricas del EC2)
  - [x] cAdvisor (Métricas de contenedores)
  - [x] Loki (Servidor de logs)
  - [x] Promtail (Recolector de logs)
  - [x] Grafana (Visualización)

- [x] **Dockerfiles** optimizados para cada servicio
- [x] **Configuración de red** Docker (app-network)
- [x] **Volúmenes persistentes** para datos

### 2. Observabilidad (Stack Grafana) ✅

#### Prometheus
- [x] Archivo `prometheus.yml` configurado
- [x] Scraping de múltiples targets:
  - [x] Node Exporter (métricas del EC2)
  - [x] cAdvisor (métricas de contenedores)
  - [x] Prometheus mismo
  - [x] Grafana
  - [x] Loki
- [x] Intervalo de scraping: 15s
- [x] Retención de datos: 15 días

#### Loki
- [x] Archivo `loki-config.yml` configurado
- [x] Almacenamiento en filesystem
- [x] Retención de logs: 7 días
- [x] Límites de ingesta configurados

#### Promtail
- [x] Archivo `promtail-config.yml` configurado
- [x] Recolección de logs de Docker
- [x] Recolección de logs de archivos
- [x] Labels automáticos por servicio

#### Grafana
- [x] Datasources provisionados automáticamente:
  - [x] Prometheus (métricas)
  - [x] Loki (logs)
- [x] Dashboard: **EC2 Infrastructure Monitoring**
  - [x] CPU Usage
  - [x] Memory Usage
  - [x] Disk Usage
  - [x] Network Traffic
  - [x] System Uptime
- [x] Dashboard: **Application Logs**
  - [x] Backend logs
  - [x] Frontend logs
  - [x] Error logs
  - [x] Log volume por servicio

### 3. CI/CD Pipeline ✅

- [x] **GitHub Actions Workflow** (`.github/workflows/deploy.yml`)
  - [x] Job: Build and Test
    - [x] Build Backend Docker image
    - [x] Build Frontend Docker image
    - [x] Upload artifacts
  - [x] Job: Deploy
    - [x] SSH a EC2
    - [x] Copiar archivos
    - [x] Ejecutar docker-compose
    - [x] Verificar despliegue
  - [x] Job: Notify
    - [x] Notificación a Discord en éxito
    - [x] Notificación a Discord en fallo

- [x] **Discord Webhooks** configurados
  - [x] Mensaje con commit SHA
  - [x] Mensaje con autor
  - [x] Mensaje con URLs de servicios
  - [x] Colores diferentes para éxito/fallo

### 4. Infraestructura como Código (Terraform) ✅

- [x] **main.tf** - Provider de AWS
- [x] **variables.tf** - Variables configurables
- [x] **ec2.tf** - Instancia EC2 completa:
  - [x] Security Group con todos los puertos
  - [x] Amazon Linux 2023 AMI
  - [x] User data script (Docker, Docker Compose, Git, Swap)
  - [x] Volumen EBS 20GB
  - [x] Elastic IP
- [x] **outputs.tf** - Outputs útiles (IPs, URLs, SSH)
- [x] **terraform.tfvars.example** - Ejemplo de variables
- [x] **.gitignore** - Archivos de Terraform excluidos

### 5. Documentación ✅

- [x] **README.md** principal
  - [x] Descripción del proyecto
  - [x] Stack tecnológico
  - [x] Diagrama de arquitectura ASCII
  - [x] Instrucciones de instalación
  - [x] Acceso a servicios
  - [x] Comandos útiles
  - [x] Troubleshooting

- [x] **docs/DEPLOYMENT_GUIDE.md**
  - [x] Guía paso a paso completa
  - [x] 6 fases de despliegue
  - [x] Comandos específicos
  - [x] Verificación de cada paso
  - [x] Solución de problemas comunes

- [x] **docs/GITHUB_SECRETS.md**
  - [x] Instrucciones para EC2_SSH_KEY
  - [x] Instrucciones para DISCORD_WEBHOOK_URL
  - [x] Troubleshooting de secretos

- [x] **docs/ARCHITECTURE.md**
  - [x] Diagrama de arquitectura detallado
  - [x] Flujo de datos
  - [x] Puertos y servicios
  - [x] Volúmenes Docker
  - [x] Recursos de infraestructura
  - [x] Estrategia de monitoreo
  - [x] Seguridad
  - [x] Disaster recovery

### 6. Archivos de Configuración ✅

- [x] **.env.example** - Ejemplo de variables de entorno
- [x] **.env** - Variables de entorno (no commiteado)
- [x] **.gitignore** - Archivos excluidos del repo

---

## 📝 Pasos Siguientes (Para el Estudiante)

### A. Configuración Inicial

1. [ ] **Configurar AWS**
   ```bash
   aws configure
   # Ingresar Access Key y Secret Key
   ```

2. [ ] **Crear Infraestructura**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Editar terraform.tfvars con tu IP
   terraform init
   terraform apply
   ```

3. [ ] **Guardar Key Pair**
   - Descargar `devops-casa-cambios.pem` desde AWS Console
   - Guardar en lugar seguro
   - NO commitear al repositorio

### B. Configurar GitHub

1. [ ] **Crear Repositorio en GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: DevOps project setup"
   git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
   git push -u origin main
   ```

2. [ ] **Configurar Secretos en GitHub**
   - [ ] Agregar `EC2_SSH_KEY` (contenido del .pem)
   - [ ] Agregar `DISCORD_WEBHOOK_URL`

3. [ ] **Actualizar IP en Workflow**
   - Editar `.github/workflows/deploy.yml`
   - Cambiar `EC2_HOST` por tu IP real

### C. Primer Despliegue

1. [ ] **Conectarse al EC2**
   ```bash
   ssh -i devops-casa-cambios.pem ec2-user@TU_IP
   ```

2. [ ] **Clonar Repositorio**
   ```bash
   git clone https://github.com/TU_USUARIO/TU_REPO.git
   cd TU_REPO
   ```

3. [ ] **Crear .env**
   ```bash
   cp .env.example .env
   # Editar si es necesario
   ```

4. [ ] **Desplegar**
   ```bash
   docker-compose up -d
   docker-compose ps
   ```

5. [ ] **Verificar Servicios**
   - [ ] Frontend: http://TU_IP
   - [ ] Backend: http://TU_IP:3000
   - [ ] Grafana: http://TU_IP:3001

### D. Configurar Grafana

1. [ ] **Acceder a Grafana**
   - URL: http://TU_IP:3001
   - Login: admin / admin123

2. [ ] **Verificar Datasources**
   - [ ] Prometheus conectado
   - [ ] Loki conectado

3. [ ] **Verificar Dashboards**
   - [ ] EC2 Infrastructure mostrando datos
   - [ ] Application Logs mostrando logs

### E. Probar CI/CD

1. [ ] **Hacer un cambio**
   ```bash
   echo "Test" >> README.md
   git add .
   git commit -m "test: CI/CD pipeline"
   git push origin main
   ```

2. [ ] **Verificar Pipeline**
   - [ ] GitHub Actions se ejecutó
   - [ ] Build exitoso
   - [ ] Deploy exitoso
   - [ ] Notificación en Discord recibida

### F. Capturas para Entrega

1. [ ] **Captura: Dashboard de Grafana - Infraestructura**
   - Mostrando CPU, RAM, Disco con datos reales
   - Timestamp visible

2. [ ] **Captura: Dashboard de Grafana - Logs**
   - Mostrando logs del backend y frontend
   - Timestamp visible

3. [ ] **Captura: Notificación de Discord**
   - Mensaje completo
   - Mostrando commit SHA, autor, URLs

4. [ ] **Captura: Terminal - docker-compose ps**
   - Todos los servicios en "Up"

5. [ ] **Captura: Terraform outputs**
   - Mostrando todas las IPs y URLs

### G. Informe Técnico

1. [ ] **Diagrama de Arquitectura**
   - Usar el de docs/ARCHITECTURE.md como base
   - Agregar herramienta visual (draw.io, Lucidchart)

2. [ ] **Estrategia de Monitoreo**
   - Explicar qué métricas se eligieron
   - Por qué son importantes
   - Cómo se configuró Prometheus

3. [ ] **Evidencia de CI/CD**
   - Screenshot del workflow YAML
   - Destacar sección de Discord webhook
   - Explicar cada paso del pipeline

4. [ ] **Sección de Problemas Encontrados**
   - Documentar problemas que tuviste
   - Cómo los solucionaste

---

## 🎯 Criterios de Evaluación

### Funcionalidad Base - 20%
- [ ] CRUD operativo
- [ ] Frontend se comunica con Backend
- [ ] Backend se comunica con DB
- [ ] Todas las funciones principales trabajan

### Contenerización - 5%
- [ ] Dockerfiles optimizados
- [ ] docker-compose bien estructurado
- [ ] Servicios se levantan correctamente

### CI/CD y Notificaciones - 20%
- [ ] Pipeline funcional
- [ ] **CRÍTICO:** Notificación a Discord llega tras despliegue
- [ ] Build automático
- [ ] Deploy automático

### Observabilidad (Monitoreo) - 25% ⭐ CRÍTICO
- [ ] Dashboard de Grafana funcionando
- [ ] **Métricas de infraestructura** (CPU/RAM) visibles
- [ ] **Logs de aplicación** visibles
- [ ] Prometheus recolectando datos
- [ ] Loki centralizando logs

### Infraestructura AWS - 20%
- [ ] Instancia EC2 configurada correctamente
- [ ] Security Groups con puertos correctos
- [ ] **Todo creado con Terraform**
- [ ] Infraestructura reproducible

### Documentación - 10%
- [ ] README completo
- [ ] Diagramas claros
- [ ] Informe técnico profesional
- [ ] Capturas de pantalla de calidad

---

## 📦 Entregables Finales

### Repositorio Git
- [x] Código fuente (Front + Back)
- [x] Dockerfiles
- [x] docker-compose.yml
- [x] Configuración de monitoreo
- [x] GitHub Actions workflows
- [x] Terraform files
- [x] README.md

### Instancia EC2
- [ ] Activa y accesible el día de revisión
- [ ] Todos los servicios corriendo
- [ ] Puertos accesibles

### Documentación
- [ ] Diagrama de arquitectura
- [ ] Capturas de pantalla
- [ ] Informe técnico PDF

---

## 🚀 Estado del Proyecto

**COMPLETADO:** ✅ Toda la base técnica está lista

**PENDIENTE:** ⏳ Configuración específica del estudiante:
- Terraform apply (crear EC2)
- Configurar GitHub Secrets
- Primer despliegue
- Capturas de pantalla
- Informe técnico

**SIGUIENTE PASO:** 🎯 Seguir la guía en `docs/DEPLOYMENT_GUIDE.md`

---

## 💡 Consejos Finales

1. **No esperes al último minuto** - Terraform puede tardar en crear recursos
2. **Prueba todo antes de presentar** - Asegúrate que todo funciona
3. **Documenta mientras trabajas** - No dejes la documentación para el final
4. **Toma capturas en alta resolución** - Son parte de la evaluación
5. **Guarda backups** - De tu .pem, .env, y configuraciones importantes
6. **Revisa los logs** - Si algo no funciona, los logs te dirán por qué
7. **Pregunta si tienes dudas** - Es mejor preguntar que entregar algo mal

**¡Éxito con tu proyecto! 🎉**
