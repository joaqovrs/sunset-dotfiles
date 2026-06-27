# my-hyprland-dotfiles

Mis dotfiles de Hyprland en Arch Linux.

## Incluye

| Config | Descripción |
|--------|-------------|
| `hypr` | Compositor Hyprland + hyprsunset |
| `waybar` | Barra de estado |
| `kitty` | Terminal |
| `rofi` | Lanzador de aplicaciones |
| `mako` | Notificaciones |
| `matugen` | Generación de temas (Material You) |
| `cava` | Visualizador de audio |
| `fastfetch` | Info del sistema |

## Instalación

Clonar y copiar (o symlinkear) los directorios a `~/.config`:

```bash
git clone https://github.com/joaqovrs/my-hyprland-dotfiles.git
cd my-hyprland-dotfiles
cp -a .config/* ~/.config/
```

> Hacé backup de tu `~/.config` actual antes de copiar.
