#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║   theme-switch.sh                        ║
# ║   Alterna Kitty entre Tokyo Night Storm  ║
# ║   y Catppuccin Mocha                     ║
# ╚══════════════════════════════════════════╝
#
# Uso:
#   ./theme-switch.sh              → alterna al opuesto del actual
#   ./theme-switch.sh tokyo        → fuerza Tokyo Night Storm
#   ./theme-switch.sh catppuccin   → fuerza Catppuccin Mocha

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[theme]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }

KITTY_CONF="$HOME/.config/kitty/kitty.conf"
STATE_FILE="$HOME/.cache/kitty-theme"

# ── Colores Tokyo Night Storm ─────────────
TOKYO_COLORS=$(cat << 'COLORS'
# ── Tokyo Night Storm Colorscheme ────────
background             #24283b
foreground             #c0caf5
selection_background   #283457
selection_foreground   #c0caf5
url_color              #7dcfff
cursor                 #c0caf5
cursor_text_color      #24283b
color0  #1d202f
color8  #414868
color1  #f7768e
color9  #f7768e
color2  #9ece6a
color10 #9ece6a
color3  #e0af68
color11 #e0af68
color4  #7aa2f7
color12 #7aa2f7
color5  #bb9af7
color13 #bb9af7
color6  #7dcfff
color14 #7dcfff
color7  #a9b1d6
color15 #c0caf5
active_border_color    #7aa2f7
inactive_border_color  #414868
active_tab_background  #7aa2f7
active_tab_foreground  #24283b
inactive_tab_background #1f2335
inactive_tab_foreground #a9b1d6
COLORS
)

# ── Colores Catppuccin Mocha ──────────────
CATPPUCCIN_COLORS=$(cat << 'COLORS'
# ── Catppuccin Mocha Colorscheme ─────────
background             #1e1e2e
foreground             #cdd6f4
selection_background   #313244
selection_foreground   #cdd6f4
url_color              #89dceb
cursor                 #f5e0dc
cursor_text_color      #1e1e2e
color0  #45475a
color8  #585b70
color1  #f38ba8
color9  #f38ba8
color2  #a6e3a1
color10 #a6e3a1
color3  #f9e2af
color11 #f9e2af
color4  #89b4fa
color12 #89b4fa
color5  #cba6f7
color13 #cba6f7
color6  #89dceb
color14 #89dceb
color7  #bac2de
color15 #a6adc8
active_border_color    #cba6f7
inactive_border_color  #45475a
active_tab_background  #cba6f7
active_tab_foreground  #1e1e2e
inactive_tab_background #181825
inactive_tab_foreground #bac2de
COLORS
)

# ── Aplicar tema a kitty.conf ─────────────
apply_theme() {
  local theme_name="$1"
  local theme_colors="$2"

  # Eliminar bloque de colores anterior (entre markers)
  sed -i '/# ── Tokyo Night Storm Colorscheme/,/inactive_tab_foreground.*/d' "$KITTY_CONF"
  sed -i '/# ── Catppuccin Mocha Colorscheme/,/inactive_tab_foreground.*/d' "$KITTY_CONF"

  # Insertar nuevo bloque de colores
  echo "" >> "$KITTY_CONF"
  echo "$theme_colors" >> "$KITTY_CONF"

  # Guardar estado actual
  mkdir -p "$(dirname $STATE_FILE)"
  echo "$theme_name" > "$STATE_FILE"

  # Recargar Kitty si está abierto
  if pgrep -x kitty > /dev/null; then
    kitty @ --to unix:/tmp/kitty load-config 2>/dev/null || true
  fi

  ok "Tema aplicado: $theme_name"
}

# ── Resolver qué tema aplicar ─────────────
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "tokyo")

if [ "$1" = "tokyo" ]; then
  TARGET="tokyo"
elif [ "$1" = "catppuccin" ]; then
  TARGET="catppuccin"
else
  # Toggle
  [ "$CURRENT" = "tokyo" ] && TARGET="catppuccin" || TARGET="tokyo"
fi

# ── Aplicar ───────────────────────────────
if [ "$TARGET" = "tokyo" ]; then
  log "Cambiando a Tokyo Night Storm..."
  apply_theme "tokyo" "$TOKYO_COLORS"
  echo -e "  Tema: ${BLUE}Tokyo Night Storm${NC}"
else
  log "Cambiando a Catppuccin Mocha..."
  apply_theme "catppuccin" "$CATPPUCCIN_COLORS"
  echo -e "  Tema: ${GREEN}Catppuccin Mocha${NC}"
fi
