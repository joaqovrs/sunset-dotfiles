#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Crear entradas para rofi con iconos (ruta directa, sin miniaturas)
TMPFILE=$(mktemp)

find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort | while IFS= read -r file; do
    name=$(basename "$file")
    echo -en "${name}\0icon\x1f${file}\n"
done > "$TMPFILE"

SELECTED=$(rofi \
    -dmenu \
    -i \
    -p "  Wallpaper" \
    -show-icons \
    -theme-str 'window { background-color: #111111; width: 680px; } mainbox { background-color: #111111; } inputbar { background-color: #1e1e1e; text-color: #ffffff; } prompt { text-color: #ffffff; } entry { text-color: #ffffff; } listview { columns: 3; lines: 3; background-color: #111111; spacing: 2px; } element { padding: 0px; orientation: vertical; background-color: #111111; border-radius: 0px; border: 0px; } element selected { background-color: #111111; border: 3px; border-color: #ffffff; } element-icon { size: 200px; expand: true; background-color: #111111; } element-text { enabled: false; width: 0; }' \
    < "$TMPFILE")

rm -f "$TMPFILE"

if [[ -n "$SELECTED" ]]; then
    ~/.local/bin/set-wallpaper.sh "$WALLPAPER_DIR/$SELECTED"
fi
