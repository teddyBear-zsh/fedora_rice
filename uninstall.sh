#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║   uninstall.sh                           ║
# ║   Elimina symlinks y restaura backups    ║
# ╚══════════════════════════════════════════╝

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${BLUE}[uninstall]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# ── Mostrar symlinks que se van a eliminar ────────────────────
echo ""
echo -e "${YELLOW}Symlinks encontrados apuntando a ~/dotfiles:${NC}"
echo ""

FOUND=0
while IFS= read -r link; do
  target=$(readlink "$link")
  if [[ "$target" == *dotfiles* ]]; then
    echo -e "  ${RED}✗${NC} $link → $target"
    FOUND=1
  fi
done < <(find "$CONFIG_DIR" -maxdepth 1 -type l)

# .zshrc
if [ -L "$HOME/.zshrc" ] && [[ "$(readlink ~/.zshrc)" == *dotfiles* ]]; then
  echo -e "  ${RED}✗${NC} ~/.zshrc → $(readlink ~/.zshrc)"
  FOUND=1
fi

if [ "$FOUND" -eq 0 ]; then
  warn "No se encontraron symlinks de dotfiles. Nada que limpiar."
  exit 0
fi

echo ""
read -p "¿Eliminar todos estos symlinks? [s/N] " confirm
[[ "$confirm" != "s" && "$confirm" != "S" ]] && echo "Cancelado." && exit 0

echo ""

# ── Eliminar symlinks en .config ──────────────────────────────
log "Eliminando symlinks en ~/.config..."
while IFS= read -r link; do
  target=$(readlink "$link")
  if [[ "$target" == *dotfiles* ]]; then
    unlink "$link"
    ok "Eliminado: $link"
  fi
done < <(find "$CONFIG_DIR" -maxdepth 1 -type l)

# ── Eliminar .zshrc symlink ───────────────────────────────────
if [ -L "$HOME/.zshrc" ] && [[ "$(readlink ~/.zshrc)" == *dotfiles* ]]; then
  unlink "$HOME/.zshrc"
  ok "Eliminado: ~/.zshrc"
fi

# ── Restaurar backup ──────────────────────────────────────────
echo ""
BACKUPS=($(ls -d "$HOME"/.config-backup-* 2>/dev/null | sort -r))

if [ ${#BACKUPS[@]} -eq 0 ]; then
  warn "No se encontraron backups para restaurar."
else
  echo -e "${YELLOW}Backups disponibles:${NC}"
  for i in "${!BACKUPS[@]}"; do
    echo "  [$i] ${BACKUPS[$i]}"
  done
  echo "  [n] No restaurar ninguno"
  echo ""
  read -p "¿Cuál restaurar? [0/${#BACKUPS[@]}-1/n] " choice

  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -lt "${#BACKUPS[@]}" ]; then
    BACKUP="${BACKUPS[$choice]}"
    log "Restaurando desde $BACKUP..."
    for item in "$BACKUP"/*/; do
      name=$(basename "$item")
      dest="$CONFIG_DIR/$name"
      if [ -e "$dest" ]; then
        warn "$dest ya existe, saltando..."
      else
        cp -r "$item" "$dest"
        ok "Restaurado: ~/.config/$name"
      fi
    done

    # Restaurar .zshrc si estaba en el backup
    if [ -f "$BACKUP/.zshrc" ]; then
      cp "$BACKUP/.zshrc" "$HOME/.zshrc"
      ok "Restaurado: ~/.zshrc"
    fi
  else
    warn "No se restauró ningún backup."
  fi
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  Limpieza completada ✓               ${NC}"
echo -e "${GREEN}══════════════════════════════════════${NC}"
