#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║   install.sh                             ║
# ║   Linkea dotfiles con backup automático  ║
# ╚══════════════════════════════════════════╝

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${BLUE}[dotfiles]${NC} $1"; }
ok()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"

log "Dotfiles dir: $DOTFILES_DIR"
log "Config dir:   $CONFIG_DIR"

# ── Backup ────────────────────────────────────────────────────
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        warn "Backup: $target → $BACKUP_DIR/$(basename $target)"
        mv "$target" "$BACKUP_DIR/"
    fi
}

# ── Symlink .config dirs ──────────────────────────────────────
log "Linkeando configs en ~/.config ..."
for dir in "$DOTFILES_DIR/.config"/*/; do
    name=$(basename "$dir")
    target="$CONFIG_DIR/$name"
    backup_if_exists "$target"
    ln -sf "$dir" "$target"
    ok "Linked: ~/.config/$name"
done

# ── GTK Settings via gsettings ────────────────────────────────
log "Aplicando tema GTK, iconos y cursor via gsettings..."

gsettings set org.gnome.desktop.interface gtk-theme        "catppuccin-mocha-mauve-standard+default"
gsettings set org.gnome.desktop.interface icon-theme       "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme     "catppuccin-mocha-mauve-cursors"
gsettings set org.gnome.desktop.interface cursor-size      24
gsettings set org.gnome.desktop.interface font-name        "JetBrainsMono Nerd Font 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Mono 12"
gsettings set org.gnome.desktop.interface document-font-name  "JetBrainsMono Nerd Font 11"
gsettings set org.gnome.desktop.interface color-scheme     "prefer-dark"

ok "Tema aplicado"

# ── Fuente en terminales ──────────────────────────────────────
log "Configurando fuente en GNOME Terminal como fallback..."
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
if [ -n "$PROFILE" ]; then
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ \
        font "JetBrainsMono Nerd Font Mono 12"
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ \
        use-system-font false
fi

# ── Symlink .zshrc ───────────────────────────────────────────
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    backup_if_exists "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ok "Linked: ~/.zshrc"
fi

# ── Scripts ejecutables ───────────────────────────────────────
if [ -d "$DOTFILES_DIR/.scripts" ]; then
    chmod +x "$DOTFILES_DIR/.scripts/"* 2>/dev/null || true
    ok "Scripts marcados como ejecutables"
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Dotfiles aplicados correctamente 🎉     ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Pasos manuales restantes:${NC}"
echo "  1. Abre GNOME Tweaks → Appearance → Shell → catppuccin-mocha-mauve"
echo "  2. Instala extensiones desde extensions.gnome.org:"
echo "     - Forge"
echo "     - Blur My Shell"
echo "     - Just Perfection"
echo "     - Open Bar"
echo "     - Quick Settings Tweaks"
echo "     - User Themes"
echo "  3. Instala Catppuccin en Firefox: github.com/catppuccin/firefox"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Backup guardado en:${NC} $BACKUP_DIR"
fi