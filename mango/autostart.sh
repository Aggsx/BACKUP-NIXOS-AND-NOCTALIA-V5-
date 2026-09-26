#!/usr/bin/env bash

# Matar procesos previos de forma segura
pkill -9 waybar || true
pkill -9 qs || true

# Esperar un momento para asegurar que los sockets se liberen
sleep 0.5

# Fondo de pantalla (Usando el que ya tienes en tus paquetes)
# swaybg -i /ruta/a/tu/fondo.jpg &

# LANZAR NOCTALIA (Usando el comando del paquete que tienes en el Flake)
# Agregamos una pequeña pausa para que el compositor cargue bien primero
sleep 1 && noctalia &
