#!/bin/bash

# Este script instala Grafana Enterprise y lo configura para iniciar automáticamente

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar dependencias necesarias
echo "Instalando dependencias..."
sudo apt-get install -y adduser libfontconfig1 musl

# Descargar el paquete .deb de Grafana Enterprise
echo "Descargando Grafana Enterprise..."
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_12.1.0_amd64.deb

# Instalar Grafana
echo "Instalando Grafana..."
sudo dpkg -i grafana-enterprise_12.1.0_amd64.deb

# Resolver dependencias faltantes (si las hay)
echo "Instalando dependencias faltantes..."
sudo apt-get install -f -y

# Iniciar el servicio de Grafana
echo "Iniciando el servicio de Grafana..."
sudo systemctl start grafana-server

# Habilitar Grafana para que se inicie automáticamente al arrancar el sistema
echo "Habilitando Grafana para iniciar automáticamente..."
sudo systemctl enable grafana-server

# Verificar que el servicio de Grafana esté en funcionamiento
echo "Verificando el estado del servicio de Grafana..."
sudo systemctl status grafana-server

# Obtener la dirección IP del equipo
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Información adicional para acceder a Grafana
echo "Grafana se ha instalado correctamente."
echo "Puedes acceder a Grafana a través de tu navegador en http://$IP_ADDRESS:3000"
echo "Las credenciales por defecto son:"
echo "  Usuario: admin"
echo "  Contraseña: admin"
echo "Recuerda cambiar la contraseña al iniciar sesión por primera vez."

# Fin del script
echo "Instalación completada."
