#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31mError en la línea $LINENO\e[0m"; exit 1' ERR

# Colores
COLOR_INFO="\e[36m"      # Cyan
COLOR_OK="\e[32m"        # Verde
COLOR_WARN="\e[33m"      # Amarillo
COLOR_ERROR="\e[31m"     # Rojo
COLOR_RESET="\e[0m"
COLOR_BOLD="\e[1m"

GRAFANA_VERSION="12.1.0"
DEB_FILE="grafana-enterprise_${GRAFANA_VERSION}_amd64.deb"
DEB_URL="https://dl.grafana.com/enterprise/release/${DEB_FILE}"

echo -e "${COLOR_INFO}Actualizando el sistema...${COLOR_RESET}"
sudo apt update -y > /dev/null 2>&1
sudo apt upgrade -y > /dev/null 2>&1

echo -e "${COLOR_INFO}Instalando dependencias...${COLOR_RESET}"
sudo apt install -y adduser libfontconfig1 musl > /dev/null 2>&1

if [[ -f "$DEB_FILE" ]]; then
  echo -e "${COLOR_WARN}El archivo ${DEB_FILE} ya existe, no se descarga de nuevo.${COLOR_RESET}"
else
  echo -e "${COLOR_INFO}Descargando ${DEB_FILE}...${COLOR_RESET}"
  wget -q "$DEB_URL"
fi

echo -e "${COLOR_INFO}Instalando Grafana...${COLOR_RESET}"
sudo dpkg -i "$DEB_FILE" > /dev/null 2>&1

echo -e "${COLOR_INFO}Instalando dependencias faltantes...${COLOR_RESET}"
sudo apt install -f -y > /dev/null 2>&1

echo -e "${COLOR_INFO}Iniciando el servicio de Grafana...${COLOR_RESET}"
sudo systemctl start grafana-server

echo -e "${COLOR_INFO}Habilitando Grafana para iniciar automáticamente...${COLOR_RESET}"
sudo systemctl enable grafana-server

if sudo systemctl is-active --quiet grafana-server; then
  echo -e "${COLOR_OK}Grafana está activo y funcionando.${COLOR_RESET}"
else
  echo -e "${COLOR_ERROR}Grafana NO está activo. Revisa el servicio.${COLOR_RESET}"
  sudo systemctl status grafana-server --no-pager -n 20
  exit 1
fi

IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo -e "${COLOR_BOLD}Grafana se ha instalado correctamente.${COLOR_RESET}"
echo -e "${COLOR_BOLD}Accede a Grafana en: ${COLOR_OK}http://$IP_ADDRESS:3000${COLOR_RESET}"
echo -e "${COLOR_BOLD}Credenciales por defecto:${COLOR_RESET}"
echo -e " Usuario: ${COLOR_OK}admin${COLOR_RESET}"
echo -e " Contraseña: ${COLOR_OK}admin${COLOR_RESET}"
echo -e "${COLOR_WARN}Recuerda cambiar la contraseña al iniciar sesión por primera vez.${COLOR_RESET}"
echo -e "${COLOR_BOLD}Instalación completada.${COLOR_RESET}"
