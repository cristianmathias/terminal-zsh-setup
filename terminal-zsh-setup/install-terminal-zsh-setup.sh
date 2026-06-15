#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/Brewfile"
ZSHRC="${HOME}/.zshrc"
GITIGNORE_GLOBAL="${HOME}/.gitignore_global"
MANAGED_START="# >>> terminal-zsh-setup managed block >>>"
MANAGED_END="# <<< terminal-zsh-setup managed block <<<"
INSTALL_PACKAGES=1
CONFIGURE_TERMINAL_FONT=1
INSTALL_NEOVIM_CONFIG=1
REINSTALL_NEOVIM_CONFIG=0

usage() {
  cat <<'EOF'
Usage:
  ./terminal-zsh-setup/install-terminal-zsh-setup.sh [options]

Options:
  --no-packages          Do not run brew bundle. Only apply shell/Git config.
  --no-terminal-font     Do not attempt to configure Terminal.app font.
  --no-neovim            Do not install the LazyVim starter config.
  --reinstall-neovim     Back up existing Neovim data and reinstall LazyVim config.
  --help                 Show this help.

What this script does:
  - optionally installs the packages from terminal-zsh-setup/Brewfile;
  - backs up ~/.zshrc;
  - replaces only its own managed block in ~/.zshrc;
  - configures Git/delta settings documented in terminal-zsh-guide.md;
  - creates ~/.gitignore_global with common macOS/editor ignores;
  - installs a LazyVim starter config for Neovim when no config exists;
  - fixes common zsh completion permissions when possible.
EOF
}

log() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-packages)
        INSTALL_PACKAGES=0
        ;;
      --no-terminal-font)
        CONFIGURE_TERMINAL_FONT=0
        ;;
      --no-neovim)
        INSTALL_NEOVIM_CONFIG=0
        ;;
      --reinstall-neovim)
        REINSTALL_NEOVIM_CONFIG=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        printf 'Unknown option: %s\n\n' "$1" >&2
        usage >&2
        exit 2
        ;;
    esac
    shift
  done
}

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This setup is intended for macOS.\n' >&2
    exit 1
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew found: $(brew --prefix)"
    return
  fi

  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew_bundle() {
  [[ "$INSTALL_PACKAGES" -eq 1 ]] || {
    log "Skipping package installation"
    return
  }

  if [[ ! -f "$BREWFILE" ]]; then
    printf 'Brewfile not found: %s\n' "$BREWFILE" >&2
    exit 1
  fi

  ensure_homebrew
  log "Installing packages from $BREWFILE"
  brew bundle --file "$BREWFILE"
}

backup_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  local backup="${file}.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$file" "$backup"
  log "Backup created: $backup"
}

install_zsh_block() {
  log "Configuring zsh"
  touch "$ZSHRC"
  backup_file "$ZSHRC"

  local tmp
  tmp="$(mktemp)"

  awk -v start="$MANAGED_START" -v end="$MANAGED_END" '
    $0 == start { skip = 1; next }
    $0 == end { skip = 0; next }
    skip != 1 { print }
  ' "$ZSHRC" > "$tmp"

  cat >> "$tmp" <<'EOF'

# >>> terminal-zsh-setup managed block >>>
# Fast, developer-friendly zsh setup.

typeset -U path PATH fpath FPATH

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt auto_cd
setopt correct
setopt interactive_comments
setopt no_beep

_has_real_terminal() {
  [[ -t 1 && "$TERM" != dumb ]]
}

if [[ -d /opt/homebrew/share/zsh-completions ]]; then
  fpath=(/opt/homebrew/share/zsh-completions $fpath)
elif [[ -d /usr/local/share/zsh-completions ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

if _has_real_terminal; then
  autoload -Uz compinit
  if [[ -f "$HOME/.zcompdump" && "$HOME/.zcompdump" -nt "$HOME/.zshrc" ]]; then
    compinit -C
  else
    compinit
  fi

  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  zstyle ':completion:*' menu select
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' group-name ''
fi

export ZSH="$HOME/.oh-my-zsh"
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME=""
  plugins=(git)
  source "$ZSH/oh-my-zsh.sh"
fi

if _has_real_terminal && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if _has_real_terminal && command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if _has_real_terminal && command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export SDKMAN_DIR="$HOME/.sdkman"
_load_sdkman() {
  unset -f sdk java javac jshell jar mvn gradle 2>/dev/null
  if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    if _has_real_terminal; then
      source "$SDKMAN_DIR/bin/sdkman-init.sh"
    else
      source "$SDKMAN_DIR/bin/sdkman-init.sh" >/dev/null 2>&1
    fi
  fi
}

sdk() { _load_sdkman; sdk "$@"; }
java() { _load_sdkman; command java "$@"; }
javac() { _load_sdkman; command javac "$@"; }
jshell() { _load_sdkman; command jshell "$@"; }
jar() { _load_sdkman; command jar "$@"; }
mvn() { _load_sdkman; command mvn "$@"; }
gradle() { _load_sdkman; command gradle "$@"; }

export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx corepack yarn pnpm 2>/dev/null
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" && -n "$functions[compdef]" ]] && source "$NVM_DIR/bash_completion"
}

nvm() { _load_nvm; nvm "$@"; }
node() { _load_nvm; command node "$@"; }
npm() { _load_nvm; command npm "$@"; }
npx() { _load_nvm; command npx "$@"; }
corepack() { _load_nvm; command corepack "$@"; }
yarn() { _load_nvm; command yarn "$@"; }
pnpm() { _load_nvm; command pnpm "$@"; }

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first'
  alias la='eza -la --icons --group-directories-first'
  alias tree='eza --tree --icons'
else
  alias ll='ls -lah'
  alias la='ls -la'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

alias g='git'
alias gst='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias lg='lazygit'
alias ..='cd ..'
alias ...='cd ../..'

if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# <<< terminal-zsh-setup managed block <<<
EOF

  mv "$tmp" "$ZSHRC"
}

configure_git() {
  log "Configuring Git/delta"
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global delta.side-by-side true
  git config --global merge.conflictstyle zdiff3
  git config --global diff.colorMoved default
  git config --global core.excludesfile "$GITIGNORE_GLOBAL"

  touch "$GITIGNORE_GLOBAL"
  grep -qxF '.DS_Store' "$GITIGNORE_GLOBAL" || cat >> "$GITIGNORE_GLOBAL" <<'EOF'
.DS_Store
.idea/
.vscode/
*.log
*.tmp
EOF
}

move_path_backup() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || return 0

  local backup="${path}.backup.$(date +%Y%m%d-%H%M%S)"
  mv "$path" "$backup"
  log "Backup created: $backup"
}

install_neovim_config() {
  [[ "$INSTALL_NEOVIM_CONFIG" -eq 1 ]] || {
    log "Skipping Neovim config"
    return
  }

  if ! command -v git >/dev/null 2>&1; then
    warn "git not found; skipping LazyVim starter config"
    return
  fi

  if [[ -e "$HOME/.config/nvim" || -L "$HOME/.config/nvim" ]]; then
    if [[ "$REINSTALL_NEOVIM_CONFIG" -eq 0 ]]; then
      log "Neovim config already exists; skipping LazyVim starter config"
      return
    fi

    move_path_backup "$HOME/.config/nvim"
    move_path_backup "$HOME/.local/share/nvim"
    move_path_backup "$HOME/.local/state/nvim"
    move_path_backup "$HOME/.cache/nvim"
  fi

  log "Installing LazyVim starter config"
  mkdir -p "$HOME/.config"
  git clone --depth 1 https://github.com/LazyVim/starter "$HOME/.config/nvim"
}

fix_zsh_completion_permissions() {
  log "Fixing zsh completion permissions when possible"
  for dir in \
    /opt/homebrew/share \
    /opt/homebrew/share/zsh \
    /opt/homebrew/share/zsh-completions \
    /usr/local/share \
    /usr/local/share/zsh \
    /usr/local/share/zsh-completions
  do
    [[ -d "$dir" && -w "$dir" ]] || continue
    chmod go-w "$dir" || warn "Could not chmod $dir"
  done
}

configure_terminal_font() {
  [[ "$CONFIGURE_TERMINAL_FONT" -eq 1 ]] || {
    log "Skipping Terminal.app font configuration"
    return
  }

  if ! command -v osascript >/dev/null 2>&1; then
    return
  fi

  local profile
  profile="$(defaults read com.apple.Terminal 'Default Window Settings' 2>/dev/null || true)"
  [[ -n "$profile" ]] || return

  log "Configuring Terminal.app font for profile: $profile"
  osascript \
    -e "tell application \"Terminal\" to set font name of settings set \"$profile\" to \"JetBrainsMono Nerd Font Mono\"" \
    -e "tell application \"Terminal\" to set font size of settings set \"$profile\" to 12" \
    >/dev/null 2>&1 || warn "Could not configure Terminal.app font automatically"
}

verify_setup() {
  log "Verifying setup"
  zsh -n "$ZSHRC"
  printf '\nDone. Open a new terminal tab and run: ll\n'
}

main() {
  parse_args "$@"
  require_macos
  install_brew_bundle
  install_zsh_block
  configure_git
  install_neovim_config
  fix_zsh_completion_permissions
  configure_terminal_font
  verify_setup
}

main "$@"
