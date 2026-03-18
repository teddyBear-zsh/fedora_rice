#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║   wallpaper.sh                           ║
# ║   Aplica wallpaper + pywal colorscheme   ║
# ╚══════════════════════════════════════════╝
#
# Uso:
#   ./wallpaper.sh                        → usa wallpaper actual guardado
#   ./wallpaper.sh imagen.jpg             → aplica imagen específica
#   ./wallpaper.sh -r                     → wallpaper aleatorio de ~/wallpapers/

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${BLUE}[wallpaper]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

WALLPAPER_DIR="$HOME/dotfiles/wallpapers"
LAST_WALLPAPER="$HOME/.cache/wal/last-wallpaper"

# ── Resolver qué imagen usar ──────────────
if [ "$1" = "-r" ]; then
    # Aleatorio
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)
    [ -z "$WALLPAPER" ] && err "No se encontraron imágenes en $WALLPAPER_DIR"
    log "Wallpaper aleatorio: $(basename $WALLPAPER)"

elif [ -n "$1" ]; then
    # Imagen específica — acepta ruta absoluta o relativa a ~/wallpapers/
    if [ -f "$1" ]; then
        WALLPAPER="$1"
    elif [ -f "$WALLPAPER_DIR/$1" ]; then
        WALLPAPER="$WALLPAPER_DIR/$1"
    else
        err "No se encontró: $1"
    fi
    log "Wallpaper: $(basename $WALLPAPER)"

else
    # Usar el último aplicado
    if [ -f "$LAST_WALLPAPER" ]; then
        WALLPAPER=$(cat "$LAST_WALLPAPER")
        log "Reaplicando último wallpaper: $(basename $WALLPAPER)"
    else
        err "No hay wallpaper previo. Usa: ./wallpaper.sh <imagen.jpg>"
    fi
fi

[ ! -f "$WALLPAPER" ] && err "Archivo no encontrado: $WALLPAPER"

# ── Guardar referencia ────────────────────
mkdir -p "$(dirname $LAST_WALLPAPER)"
echo "$WALLPAPER" > "$LAST_WALLPAPER"

# ── 1. Aplicar pywal ──────────────────────
log "Generando colorscheme con pywal..."
wal -i "$WALLPAPER" -n --saturate 0.7 -q
ok "Colorscheme generado"

# ── 2. Cambiar wallpaper en GNOME ─────────
log "Aplicando wallpaper en GNOME..."
gsettings set org.gnome.desktop.background picture-uri       "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark  "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-options   "zoom"
ok "Wallpaper aplicado en GNOME"

# ── 4. Recargar colores de Wofi ───────────
log "Actualizando colores de Wofi..."
WAL_COLORS="$HOME/.cache/wal/colors.sh"

if [ -f "$WAL_COLORS" ]; then
    source "$WAL_COLORS"

    # Reescribir wofi/style.css con colores de pywal
    # Mantiene la estructura base pero actualiza los colores dinámicamente
    cat > "$HOME/.config/wofi/style.css" << EOF
    /* ╔══════════════════════════════════════╗
    ║   Wofi — pywal dynamic colors        ║
    ║   Generado por wallpaper.sh          ║
    ╚══════════════════════════════════════╝ */

* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 14px;
    outline: none;
    border: none;
}

window {
    background-color: ${color0}f7;
    border: 1.5px solid ${color4};
    border-radius: 14px;
    padding: 6px;
}

#input {
    background-color: ${color1}cc;
    color: ${color15};
    border: 1.5px solid ${color8};
    border-radius: 10px;
    padding: 10px 14px;
    margin: 8px 8px 4px 8px;
    caret-color: ${color4};
}

#input:focus {
    border-color: ${color4};
}

#input::placeholder {
    color: ${color8};
}

#scroll {
    margin: 4px 4px 8px 4px;
}

#entry {
    padding: 8px 12px;
    border-radius: 8px;
    margin: 2px 0;
}

#entry:selected {
    background-color: ${color2}cc;
}

#text {
    color: ${color15};
    padding: 0 6px;
}

#text:selected {
    color: ${color4};
    font-weight: bold;
}

#entry > #text + #text {
    color: ${color8};
    font-size: 12px;
}

#entry:selected > #text + #text {
    color: ${color6};
}

#img {
    border-radius: 6px;
}
EOF
    ok "Colores de Wofi actualizados"
else
    warn "No se encontró colors.sh de pywal"
fi

# ── Done ──────────────────────────────────
echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  Wallpaper aplicado correctamente 🎨 ${NC}"
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "  Wallpaper: ${BLUE}$(basename $WALLPAPER)${NC}"
echo -e "  Colores:   ${BLUE}pywal + Tokyo Night base${NC}"