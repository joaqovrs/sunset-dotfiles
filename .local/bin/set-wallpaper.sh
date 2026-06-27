#!/bin/bash

IMAGE="$1"

if [[ -z "$IMAGE" ]]; then
    echo "Uso: set-wallpaper.sh <ruta-imagen>"
    exit 1
fi

# Aplicar wallpaper con transición
awww img "$IMAGE" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-duration 1.5 \
    --transition-fps 60

# Guardar ruta actual para restaurar al login
echo "$IMAGE" > "$HOME/.cache/current-wallpaper"

# Generar paleta desde el wallpaper y recargar apps
matugen image "$IMAGE" --prefer=saturation

# Recargar waybar para aplicar los nuevos colores
pkill -SIGUSR2 waybar
