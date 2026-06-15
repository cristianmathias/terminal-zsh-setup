# Terminal zsh setup

Setup reproducivel para configurar um terminal `zsh` moderno em macOS e Ubuntu.

Inclui instaladores, lista de pacotes e guias de uso para ferramentas como `starship`, `eza`, `bat`, `zoxide`, `fzf`, `atuin`, `direnv`, `fd`, `ripgrep`, `git-delta`, `lazygit`, `zsh-autosuggestions`, `zsh-syntax-highlighting` e `zsh-completions`.

## Estrutura

- `terminal-zsh-guide.md`: guia operacional do setup.
- `terminal-zsh-mini-livro.md`: material de estudo e pratica.
- `terminal-zsh-setup/install-terminal-zsh-setup.sh`: instalador para macOS.
- `terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh`: instalador para Ubuntu/Linuxbrew.
- `terminal-zsh-setup/Brewfile`: pacotes Homebrew para macOS.
- `terminal-zsh-setup/Brewfile.ubuntu`: pacotes Linuxbrew para Ubuntu.

## Uso rapido

macOS:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup.sh
```

Ubuntu:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh
```

Aplicar apenas configuracoes, sem instalar pacotes:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup.sh --no-packages
./terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh --no-packages
```

## Aviso

Os instaladores alteram arquivos e configuracoes globais do usuario, incluindo `~/.zshrc`, configuracoes globais do Git e, no macOS, podem tentar ajustar a fonte do Terminal.app.

Leia `terminal-zsh-guide.md` antes de executar em uma maquina com `.zshrc` muito customizado.
