#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║   install-apps.sh                        ║
# ║   Instala todas las apps del rice        ║
# ╚══════════════════════════════════════════╝

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[dotfiles]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

# ── DNF packages ─────────────────────────────────────────────
log "Actualizando sistema..."
sudo dnf update --refresh -y

log "Instalando paquetes base..."
sudo dnf install -y \
    kitty \
    wofi \
    gnome-tweaks \
    gnome-extensions-app \
    gnome-browser-connector \
    jetbrains-mono-fonts \
    papirus-icon-theme \
    git \
    curl \
    wget \
    unzip \
    sassc \
    gtk-murrine-engine

ok "Paquetes base instalados"

# ── RPM Fusion ───────────────────────────────────────────────
log "Habilitando RPM Fusion..."
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
ok "RPM Fusion habilitado"

# ── Flatpak / Flathub ─────────────────────────────────────────
log "Configurando Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

log "Instalando Postman via Flatpak..."
flatpak install -y flathub com.getpostman.Postman
ok "Postman instalado"

# ── Zsh + Oh My Zsh ──────────────────────────────────────────
log "Instalando zsh..."
sudo dnf install -y zsh fzf fd-find bat
 
log "Cambiando shell default a zsh..."
ZSH_PATH=$(command -v zsh 2>/dev/null || echo "/usr/bin/zsh")
if [ -f "$ZSH_PATH" ]; then
  chsh -s "$ZSH_PATH"
  ok "Shell cambiado a $ZSH_PATH"
else
  warn "zsh no encontrado en PATH, cámbialo manualmente con: chsh -s /usr/bin/zsh"
fi
 
log "Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  warn "Oh My Zsh ya instalado, saltando..."
fi
 
log "Instalando plugins de zsh..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
 
# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
 
# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting     "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
 
# zsh-autocomplete
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
  git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete     "$ZSH_CUSTOM/plugins/zsh-autocomplete"
fi
 
# fzf zsh integration
if [ ! -f "$HOME/.fzf.zsh" ]; then
    $(which fzf) --zsh > "$HOME/.fzf.zsh" 2>/dev/null ||     echo "[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh" > "$HOME/.fzf.zsh"
fi
 
ok "Zsh + Oh My Zsh + plugins instalados"
# ── pywal ─────────────────────────────────────────────────────
log "Instalando pywal..."
pip install pywal --break-system-packages
ok "pywal instalado"

# ── Catppuccin GTK Theme ──────────────────────────────────────
log "Instalando Catppuccin Mocha GTK theme..."
mkdir -p ~/.themes
if [ ! -d ~/.themes/catppuccin-mocha ]; then
    git clone --depth=1 https://github.com/catppuccin/gtk.git ~/.themes/catppuccin-mocha
else
    warn "Catppuccin GTK ya existe, saltando..."
fi
ok "Catppuccin GTK instalado"

# ── Catppuccin Cursors ────────────────────────────────────────
log "Instalando Catppuccin cursors..."
mkdir -p ~/.icons
if [ ! -d ~/.icons/catppuccin-mocha-mauve-cursors ]; then
    TMP=$(mktemp -d)
    # Los cursors ahora se distribuyen como ZIP desde GitHub Releases
    wget -q "https://github.com/catppuccin/cursors/releases/latest/download/catppuccin-mocha-mauve-cursors.zip"     -O "$TMP/cursors.zip"
    unzip -q "$TMP/cursors.zip" -d "$TMP/"
    cp -r "$TMP/catppuccin-mocha-mauve-cursors" ~/.icons/
    rm -rf "$TMP"
else
    warn "Catppuccin cursors ya existen, saltando..."
fi
ok "Cursors instalados"

# ── Nerd Fonts (JetBrainsMono completo) ───────────────────────
log "Instalando JetBrainsMono Nerd Font completo..."
mkdir -p ~/.local/share/fonts/JetBrainsMono
if [ ! "$(ls -A ~/.local/share/fonts/JetBrainsMono)" ]; then
    TMP=$(mktemp -d)
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
        -O "$TMP/JetBrainsMono.zip"
    unzip -q "$TMP/JetBrainsMono.zip" -d ~/.local/share/fonts/JetBrainsMono
    rm -rf "$TMP"
    fc-cache -fv > /dev/null
else
    warn "JetBrainsMono Nerd Font ya instalado, saltando..."
fi
ok "Fuentes instaladas"

echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  Apps instaladas correctamente 🎉    ${NC}"
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo ""
echo -e "Siguiente paso: corre ${BLUE}./install.sh${NC} para aplicar los dotfiles"