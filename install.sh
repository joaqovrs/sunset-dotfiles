#!/usr/bin/env bash
#
# install.sh — Instalador de los dotfiles "Sunset" (Hyprland)
# Probado en Arch Linux y CachyOS (ambos basados en Arch).
#
# Uso:
#   ./install.sh            # instala deps + copia configs (con confirmaciones)
#   ./install.sh --no-deps  # solo copia configs, no instala paquetes
#

set -euo pipefail

# Directorio del repo (donde está este script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores para los mensajes
c_info='\033[1;34m'; c_ok='\033[1;32m'; c_warn='\033[1;33m'; c_reset='\033[0m'
info()  { echo -e "${c_info}::${c_reset} $*"; }
ok()    { echo -e "${c_ok}✔${c_reset} $*"; }
warn()  { echo -e "${c_warn}!${c_reset} $*"; }

INSTALL_DEPS=1
[[ "${1:-}" == "--no-deps" ]] && INSTALL_DEPS=0

# Todos estos paquetes están en los repos oficiales (core/extra/multilib).
# No hace falta ningún helper de AUR.
PKGS=(
  # Core Hyprland + sesión
  hyprland hyprsunset waybar
  awww                       # daemon de wallpaper (fork de swww, repo extra)
  matugen                    # theming Material You desde el wallpaper
  # Apps
  kitty rofi nautilus firefox
  # Notificaciones / aplets de sesión
  swaync blueman network-manager-applet polkit-kde-agent
  # Audio / utilidades
  cava wireplumber playerctl
  # Capturas
  hyprshot swappy
  # Extras
  fastfetch btop
  breeze-icons               # tema de iconos del launcher de rofi (breeze-dark)
  # Fuentes con iconos (necesarias para Waybar/Fastfetch/Rofi)
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
)

install_deps() {
  info "Instalando dependencias con pacman (todas están en repos oficiales)..."
  sudo pacman -S --needed "${PKGS[@]}"
  ok "Dependencias instaladas."
}

backup_config() {
  if [[ -d "$HOME/.config" ]]; then
    local bak="$HOME/.config.bak.$(date +%Y%m%d-%H%M%S)"
    info "Backup de ~/.config -> $bak"
    cp -a "$HOME/.config" "$bak"
    ok "Backup creado."
  fi
}

copy_files() {
  info "Copiando configuraciones a ~/.config ..."
  mkdir -p "$HOME/.config"
  cp -a "$DOTFILES_DIR/.config/." "$HOME/.config/"

  info "Copiando scripts a ~/.local/bin ..."
  mkdir -p "$HOME/.local/bin"
  cp -a "$DOTFILES_DIR/.local/bin/." "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/"*.sh

  info "Copiando wallpapers a ~/Pictures/Wallpapers ..."
  mkdir -p "$HOME/Pictures/Wallpapers"
  cp -an "$DOTFILES_DIR/wallpapers/." "$HOME/Pictures/Wallpapers/"

  ok "Archivos copiados."
}

main() {
  echo
  info "Instalador de dotfiles Sunset (Hyprland)"
  info "Repo: $DOTFILES_DIR"
  echo

  if [[ "$INSTALL_DEPS" -eq 1 ]]; then
    read -rp "¿Instalar dependencias con pacman? [Y/n] " a
    [[ "${a,,}" != "n" ]] && install_deps || warn "Saltando instalación de deps."
  else
    warn "Modo --no-deps: no se instalan paquetes."
  fi

  read -rp "¿Hacer backup de ~/.config antes de copiar? [Y/n] " b
  [[ "${b,,}" != "n" ]] && backup_config

  copy_files

  echo
  ok "Listo. Inicia/recarga Hyprland para aplicar los cambios."
  echo
  warn "Notas:"
  echo "  - El theming dinámico se dispara con ~/.local/bin/set-wallpaper.sh y"
  echo "    el selector con SUPER+SHIFT+W (wallpaper-picker-icons.sh)."
  echo "  - hyprland.conf referencia un par de scripts personales opcionales"
  echo "    (autostart-media.sh, powermenu) que no están incluidos; si no existen"
  echo "    simplemente se ignoran. Bórralos del config si no los usas."
  echo "  - El daemon de notificaciones real es swaync (no mako)."
}

main "$@"
