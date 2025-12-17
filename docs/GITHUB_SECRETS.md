# 📋 Guía de Configuración de GitHub Secrets

Para que el pipeline de CI/CD funcione correctamente, necesitas configurar dos secretos en GitHub.

## 🔑 Secretos Requeridos

### 1. EC2_SSH_KEY

**Descripción:** Clave privada SSH para conectarse a la instancia EC2.

**Pasos:**

1. En tu terminal local (donde tienes el archivo .pem):
   ```bash
   cat devops-casa-cambios.pem
   ```

2. Copia **TODO** el contenido, incluyendo las líneas:
   ```
   -----BEGIN RSA PRIVATE KEY-----
   [contenido de la clave]
   -----END RSA PRIVATE KEY-----
   ```

3. En GitHub:
   - Ve a tu repositorio
   - Settings → Secrets and variables → Actions
   - Click en "New repository secret"
   - Name: `EC2_SSH_KEY`
   - Value: Pega el contenido completo del archivo .pem
   - Click "Add secret"

### 2. DISCORD_WEBHOOK_URL

**Descripción:** URL del webhook de Discord para recibir notificaciones.

**Pasos:**

1. En Discord:
   - Ve a tu servidor
   - Click derecho en el canal donde quieres notificaciones → Edit Channel
   - Integrations → Webhooks → New Webhook
   - Dale un nombre (ej: "Casa Cambios CI/CD")
   - Opcional: Cambia el avatar
   - Click "Copy Webhook URL"

2. En GitHub:
   - Ve a tu repositorio
   - Settings → Secrets and variables → Actions
   - Click en "New repository secret"
   - Name: `DISCORD_WEBHOOK_URL`
   - Value: Pega la URL del webhook (debe empezar con `https://discord.com/api/webhooks/...`)
   - Click "Add secret"

## ✅ Verificación

Una vez configurados los secretos:

1. Los secretos aparecerán en: Settings → Secrets and variables → Actions
2. Deberías ver:
   - `EC2_SSH_KEY`
   - `DISCORD_WEBHOOK_URL`

3. **IMPORTANTE:** No podrás ver el valor de los secretos después de crearlos (por seguridad)

## 🧪 Probar el Pipeline

Para probar que todo funciona:

```bash
# Hacer un cambio pequeño
echo "Test CI/CD" >> README.md

# Commit y push
git add .
git commit -m "Test: CI/CD pipeline"
git push origin main
```

El pipeline se ejecutará automáticamente y deberías recibir una notificación en Discord.

## 🐛 Solución de Problemas

### Error: "Permission denied (publickey)"

**Causa:** El secreto `EC2_SSH_KEY` no está configurado correctamente.

**Solución:**
1. Verifica que copiaste TODO el contenido del archivo .pem
2. Asegúrate de incluir las líneas BEGIN y END
3. No debe haber espacios extra al principio o final

### Error: "Failed to send Discord notification"

**Causa:** El webhook de Discord no es válido.

**Solución:**
1. Verifica que la URL del webhook sea correcta
2. Asegúrate de que el webhook no haya sido eliminado en Discord
3. Crea un nuevo webhook si es necesario

### El pipeline se ejecuta pero no recibo notificación

**Causa:** La URL del webhook puede estar incorrecta o el secreto no está configurado.

**Solución:**
1. Ve a Settings → Secrets and variables → Actions
2. Elimina el secreto `DISCORD_WEBHOOK_URL`
3. Créalo de nuevo con la URL correcta
4. Ejecuta el pipeline nuevamente
