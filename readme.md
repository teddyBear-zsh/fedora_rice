# dotfiles

> Fedora + GNOME · Catppuccin Mocha + Tokyo Night

---

## Stack visual

| Elemento | Tema |
|---|---|
| GTK / Shell | Catppuccin Mocha Mauve |
| Iconos | Papirus Dark + Catppuccin folders |
| Cursor | Catppuccin Mocha Mauve |
| Terminal (Kitty) | Tokyo Night Storm |
| Launcher (Wofi) | Tokyo Night Storm |
| Tiling (Forge) | Borders en #cba6f7 |
| Firefox | Catppuccin Mocha |
| Fuente | JetBrainsMono Nerd Font |

---

## Extensiones GNOME requeridas

### Instalar gnome-extensions-cli

La forma más cómoda de instalar extensiones sin navegador:

```bash
pip install gnome-extensions-cli --break-system-packages
```

### Instalar todas las extensiones de una vez

```bash
gext install \
  forge@jmmaranan.com \
  blur-my-shell@aunetx \
  just-perfection-desktop@just-perfection \
  open-bar@neuromorph \
  quick-settings-tweaks@qwreey \
  user-theme@gnome-shell-extensions.gcampax.github.com
```

### Habilitar todas

```bash
gext enable \
  forge@jmmaranan.com \
  blur-my-shell@aunetx \
  just-perfection-desktop@just-perfection \
  open-bar@neuromorph \
  quick-settings-tweaks@qwreey \
  user-theme@gnome-shell-extensions.gcampax.github.com
```

### Verificar que están activas

```bash
gext list
```

> También puedes instalarlas manualmente desde [extensions.gnome.org](https://extensions.gnome.org) con el conector de navegador (`gnome-browser-connector`).

---

## Instalación

### 1. Clonar el repo

```bash
git clone https://github.com/tuusuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Dar permisos a los scripts

```bash
chmod +x *.sh .scripts/*.sh
```

### 3. Instalar apps y temas

```bash
./install-apps.sh
```

### 4. Linkear dotfiles

```bash
./install.sh
```

### 5. Pasos manuales post-instalación

```bash
# Aplicar shell theme en GNOME Tweaks
# Appearance → Shell → catppuccin-mocha-mauve

# Firefox: instalar addon desde
# https://github.com/catppuccin/firefox
```

### Desinstalar / limpiar symlinks

```bash
./uninstall.sh
```

---

## Estructura

```
dotfiles/
├── .config/
│   ├── kitty/          # Terminal — Tokyo Night Storm
│   ├── wofi/           # Launcher — Catppuccin Mocha
│   ├── forge/          # Tiling config
│   ├── gtk-3.0/        # GTK3 overrides — Catppuccin Mocha
│   └── gtk-4.0/        # GTK4 overrides — Catppuccin Mocha
├── .scripts/
│   ├── wallpaper.sh    # Aplica wallpaper + pywal
│   └── theme-switch.sh # Alterna Tokyo Night ↔ Catppuccin en Kitty
├── .zshrc              # Zsh + Oh My Zsh + plugins + aliases
├── .gitignore
├── install.sh          # Linkea configs + aplica gsettings
├── install-apps.sh     # Instala apps, temas e iconos
├── uninstall.sh        # Elimina symlinks y restaura backups
└── README.md
```

---

## Keybinds

### Foco entre ventanas — Forge
| Keybind | Acción |
|---|---|
| `Alt + Shift + D` | Foco izquierda |
| `Alt + Shift + A` | Foco derecha |
| `Alt + Shift + W` | Foco arriba |
| `Alt + Shift + S` | Foco abajo |

### Mover ventanas — Forge
| Keybind | Acción |
|---|---|
| `Super + Shift + ←` | Mover ventana izquierda |
| `Super + Shift + →` | Mover ventana derecha |
| `Super + Shift + ↑` | Mover ventana arriba |
| `Super + Shift + ↓` | Mover ventana abajo |

### Resize de ventanas — Forge
| Keybind | Acción |
|---|---|
| `Super + Alt + ←` | Reducir ancho |
| `Super + Alt + →` | Aumentar ancho |
| `Super + Alt + ↑` | Reducir alto |
| `Super + Alt + ↓` | Aumentar alto |

### Float / Layout — Forge
| Keybind | Acción |
|---|---|
| `Super + Shift + F` | Toggle float/tile |
| `Super + Enter` | Swap con última ventana activa |
| `Super + J` | Toggle split |
| `Super + Z` | Toggle split layout |
| `Super + T` | Layout tabbed |
| `Super + G` | Toggle focus border |
| `Super + +` | Aumentar gaps |
| `Super + -` | Reducir gaps |

### Workspaces — GNOME Settings → Keyboard
| Keybind | Acción |
|---|---|
| `Super + 1-9` | Ir al workspace 1-9 |
| `Super + Shift + 1-9` | Mover ventana al workspace 1-9 |

### Apps — GNOME Settings → Keyboard → Custom Shortcuts
| Keybind | Acción | Comando |
|---|---|---|
| `Super + T` | Terminal | `kitty` |
| `Super + W` | Cerrar ventana | `close-window` |
| `Super + P` | Launcher | `wofi --show drun` |
| `Super + B` | Navegador | `firefox` |

---

## Scripts

### wallpaper.sh
```bash
wallpaper imagen.jpg     # Aplica imagen específica
wallrand                 # Wallpaper aleatorio de ~/wallpapers/
wallpaper                # Reaplicar el último usado
```

### theme-switch.sh
```bash
theme                    # Alterna Tokyo Night ↔ Catppuccin
theme-tokyo              # Fuerza Tokyo Night Storm
theme-cat                # Fuerza Catppuccin Mocha
```

---

## Aliases principales

### Git
| Alias | Comando |
|---|---|
| `gs` | `git status` |
| `ga` | `git add .` |
| `gc "msg"` | `git commit -m` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gcb <branch>` | `git checkout -b` |
| `gl` | log en árbol |
| `gundo` | deshacer último commit |

### Docker
| Alias | Comando |
|---|---|
| `dcu` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcl` | `docker compose logs -f` |
| `dps` | `docker ps` |
| `dprune` | limpiar todo |

### Node / Angular
| Alias | Comando |
|---|---|
| `nrd` | `npm run dev` |
| `nrb` | `npm run build` |
| `ngs` | `ng serve` |
| `ngg` | `ng generate` |

### MongoDB
| Alias | Comando |
|---|---|
| `mongost` | iniciar servicio |
| `mongostp` | detener servicio |
| `mongo` | abrir mongosh |

### Terraform
| Alias | Comando |
|---|---|
| `tfi` | `terraform init` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfd` | `terraform destroy` |

---

## Inspiración

- [rion-ricing](https://github.com/SeraphimeZelel/rion-ricing) por SeraphimeZelel
- [catppuccin](https://github.com/catppuccin) — paleta base del rice
- [tokyo-night](https://github.com/enkia/tokyo-night-vscode-theme) — paleta del editor y terminal