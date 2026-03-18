# ╔══════════════════════════════════════════╗
# ║   .zshrc                                 ║
# ║   Oh My Zsh + plugins + dev stack        ║
# ╚══════════════════════════════════════════╝

# ── Oh My Zsh ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

# Tema — cambia aquí si quieres otro
# Lista completa: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# ── Plugins ──────────────────────────────────────────────────
plugins=(
  git
  docker
  docker-compose
  node
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete
  fzf
  history
  colored-man-pages
  command-not-found
)

source $ZSH/oh-my-zsh.sh

# ── fzf ──────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#89dceb,hl:#89b4fa
  --color=fg:#cdd6f4,header:#89b4fa,info:#cba6f7,pointer:#89dceb
  --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#89b4fa
  --border rounded --prompt '❯ ' --pointer '▶' --marker '✓'
"

# ── NVM ───────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── SDKMAN (Kotlin) ───────────────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ── AWS CLI ───────────────────────────────────────────────────
export AWS_CLI_AUTO_PROMPT=on-partial

# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"

# ── Editor ────────────────────────────────────────────────────
export EDITOR="code"
export VISUAL="code"

# ── Lang ──────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ── Historial ─────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ════════════════════════════════════════════════════════════════
# ALIASES
# ════════════════════════════════════════════════════════════════

# ── Sistema ───────────────────────────────────────────────────
alias ll="ls -lah --color=auto"
alias la="ls -A --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias cls="clear"
alias reload="source ~/.zshrc"
alias zshrc="code ~/.zshrc"

# ── DNF ───────────────────────────────────────────────────────
alias update="sudo dnf update --refresh"
alias install="sudo dnf install"
alias remove="sudo dnf remove"
alias search="dnf search"

# ── Git ───────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gundo="git reset --soft HEAD~1"

# ── Docker ────────────────────────────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dprune="docker system prune -af"
alias dimg="docker images"

# ── Node / NPM ────────────────────────────────────────────────
alias ni="npm install"
alias nid="npm install --save-dev"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nlg="npm list -g --depth=0"

# ── Angular ───────────────────────────────────────────────────
alias ng="npx @angular/cli"
alias ngs="ng serve"
alias ngg="ng generate"
alias ngb="ng build"
alias ngt="ng test"

# ── MongoDB ───────────────────────────────────────────────────
alias mongost="sudo systemctl start mongod"
alias mongostp="sudo systemctl stop mongod"
alias mongostatus="sudo systemctl status mongod"
alias mongo="mongosh"

# ── Terraform ─────────────────────────────────────────────────
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfv="terraform validate"
alias tff="terraform fmt"

# ── AWS ───────────────────────────────────────────────────────
alias awsid="aws sts get-caller-identity"
alias awsregion="aws configure get region"

# ── Scripts del rice ──────────────────────────────────────────
alias wallpaper="~/.scripts/wallpaper.sh"
alias wallrand="~/.scripts/wallpaper.sh -r"
alias theme="~/.scripts/theme-switch.sh"
alias theme-tokyo="~/.scripts/theme-switch.sh tokyo"
alias theme-cat="~/.scripts/theme-switch.sh catppuccin"

# ── Utilidades ────────────────────────────────────────────────
alias ports="ss -tulpn"
alias myip="curl -s ifconfig.me"
alias diskuse="df -h"
alias memuse="free -h"
alias cpuuse="top -bn1 | grep 'Cpu(s)'"
