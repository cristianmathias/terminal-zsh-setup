# Guia do terminal zsh

Este guia explica como usar, instalar e ajustar um setup moderno de terminal com `zsh`.

## Resumo

O setup otimiza o `zsh` para uso diario com:

- prompt moderno com `starship`;
- listagem de arquivos com icones via `eza`;
- navegacao inteligente com `zoxide`;
- busca fuzzy com `fzf`;
- historico melhorado com `atuin`;
- Git mais legivel com `delta` e `lazygit`;
- carregamento sob demanda de `nvm` e `sdkman`;
- completions, sugestoes e syntax highlighting para o shell.

O arquivo principal modificado pelos instaladores e:

```zsh
~/.zshrc
```

Material de estudo e pratica:

```text
terminal-zsh-mini-livro.md
```

Antes de alterar `~/.zshrc`, os instaladores criam um backup no formato:

```text
~/.zshrc.backup.YYYYMMDD-HHMMSS
```

## Fonte recomendada

Para renderizar corretamente os icones usados por `eza`, `starship` e outros CLIs modernos, use uma Nerd Font. A fonte recomendada e:

```bash
font-jetbrains-mono-nerd-font
```

Se os icones aparecerem como quadradinhos, confira a fonte selecionada no terminal:

```text
Terminal > Settings > Profiles > Text > Font
```

Escolha alguma variante de:

```text
JetBrainsMono Nerd Font Mono
```

## Pacotes

Pacotes usados pelo setup:

```bash
brew install fzf zoxide eza bat git-delta starship atuin direnv fd lazygit zsh-autosuggestions zsh-syntax-highlighting zsh-completions
brew install --cask font-jetbrains-mono-nerd-font
```

## Instalacao no macOS

O bootstrap fica em:

```text
terminal-zsh-setup/
```

Arquivos:

```text
terminal-zsh-setup/Brewfile
terminal-zsh-setup/Brewfile.ubuntu
terminal-zsh-setup/install-terminal-zsh-setup.sh
terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh
```

O `Brewfile` declara os pacotes de terminal e a fonte para macOS. O instalador:

- instala Homebrew se ele ainda nao existir, apenas quando a instalacao de pacotes estiver habilitada;
- roda `brew bundle` com os pacotes documentados neste guia;
- cria backup do `~/.zshrc`;
- injeta um bloco gerenciado no `~/.zshrc`;
- configura Git global com `delta` e ignore global;
- corrige permissoes comuns do `zsh compinit`;
- tenta configurar a Nerd Font no perfil padrao do Terminal.app;
- valida a sintaxe final do `~/.zshrc`.

Uso a partir da raiz do repositorio:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup.sh
```

Se quiser instalar apenas os pacotes declarados no `Brewfile`, sem aplicar dotfiles/configs:

```bash
brew bundle --file terminal-zsh-setup/Brewfile
```

Para aplicar apenas configuracoes de `~/.zshrc` e Git, sem instalar pacotes:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup.sh --no-packages
```

Se quiser evitar a tentativa de configurar fonte no Terminal.app:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup.sh --no-terminal-font
```

### Ubuntu

Para Ubuntu, use:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh
```

Esse script:

- instala pre-requisitos via `apt`, incluindo `build-essential`, `curl`, `git`, `unzip`, `fontconfig` e `zsh`;
- instala Homebrew/Linuxbrew se ele ainda nao existir;
- roda `brew bundle` usando `terminal-zsh-setup/Brewfile.ubuntu`;
- instala a JetBrainsMono Nerd Font em `~/.local/share/fonts/JetBrainsMonoNerdFont`;
- aplica o mesmo bloco gerenciado no `~/.zshrc`;
- configura Git/delta;
- corrige permissoes comuns de completions;
- valida a sintaxe do `~/.zshrc`.

Se quiser aplicar apenas configuracoes, sem instalar pacotes nem Homebrew:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh --no-packages
```

Se quiser pular a instalacao da fonte:

```bash
./terminal-zsh-setup/install-terminal-zsh-setup-ubuntu.sh --no-font
```

No Ubuntu, depois da instalacao, selecione manualmente a fonte `JetBrainsMono Nerd Font Mono` no terminal usado, como GNOME Terminal, Tilix, WezTerm, Kitty ou outro.

## Ferramentas

### eza

Substitui o `ls` com saida mais bonita, icones, cores e melhor organizacao.

Aliases configurados:

```zsh
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
```

Uso:

```zsh
ls
ll
la
tree
```

Se quiser remover icones, edite `~/.zshrc` e remova `--icons` dos aliases.

### bat

Substitui o `cat` com syntax highlighting, numeros de linha e paginacao.

Alias configurado:

```zsh
alias cat='bat'
```

Uso:

```zsh
cat arquivo.ts
bat arquivo.ts
```

Para ver saida crua, sem decoracao:

```zsh
bat --plain arquivo.ts
```

### zoxide

Substitui o habito de navegar manualmente com `cd`. Ele aprende os diretorios que voce usa e permite pular para eles por nome aproximado.

Inicializacao no `~/.zshrc`:

```zsh
eval "$(zoxide init zsh)"
```

Uso:

```zsh
z previdencia
z downloads
z github
```

Quanto mais voce usa, melhor ele fica.

### fzf

Busca fuzzy no terminal. Ajuda a encontrar arquivos, comandos e navegar por historico.

Inicializacao no `~/.zshrc`:

```zsh
source <(fzf --zsh)
```

Atalhos comuns:

```text
Ctrl+R    busca no historico
Ctrl+T    busca arquivos
Alt+C     busca diretorios
```

Observacao: `Ctrl+R` pode ser assumido pelo `atuin`, dependendo da ordem de inicializacao.

### atuin

Historico de shell melhorado, com busca rica e persistencia.

Inicializacao no `~/.zshrc`:

```zsh
eval "$(atuin init zsh --disable-up-arrow)"
```

Uso:

```text
Ctrl+R
```

Comandos uteis:

```zsh
atuin search git
atuin stats
atuin history list
```

Se quiser usar a seta para cima do `atuin`, remova `--disable-up-arrow` do `~/.zshrc`.

### direnv

Carrega variaveis de ambiente automaticamente por projeto, usando arquivos `.envrc`.

Inicializacao no `~/.zshrc`:

```zsh
eval "$(direnv hook zsh)"
```

Exemplo de uso em um projeto:

```zsh
echo 'export NODE_ENV=development' > .envrc
direnv allow
```

Depois disso, ao entrar na pasta, a variavel sera carregada automaticamente.

Importante: rode `direnv allow` apenas em projetos confiaveis, porque `.envrc` executa codigo shell.

### fd

Alternativa moderna ao `find`, mais simples e rapida.

Uso:

```zsh
fd GraphQL
fd '\.ts$'
fd schema .
```

### lazygit

Interface terminal para Git.

Alias configurado:

```zsh
alias lg='lazygit'
```

Uso:

```zsh
lg
```

Atalhos basicos:

```text
q       sair
?       ajuda
space   selecionar arquivo/hunk
c       commit
p       push/pull, dependendo do painel
```

### git-delta

Melhora a visualizacao de diffs no Git.

Configuracao global usada pelo setup:

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global merge.conflictstyle zdiff3
git config --global diff.colorMoved default
```

Uso:

```zsh
git diff
git show
git log -p
```

Se quiser desativar o modo lado a lado:

```bash
git config --global delta.side-by-side false
```

### starship

Prompt moderno e rapido.

Inicializacao no `~/.zshrc`:

```zsh
eval "$(starship init zsh)"
```

Arquivo opcional de configuracao:

```text
~/.config/starship.toml
```

Exemplo simples:

```toml
add_newline = true

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "git "
```

Se quiser remover icones do prompt, configure os modulos no `starship.toml` sem simbolos especiais.

## Plugins de zsh

### zsh-autosuggestions

Mostra sugestoes em cinza com base no historico enquanto voce digita.

Carregado no `~/.zshrc`:

```zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

Uso:

```text
Seta direita ou End    aceitar sugestao
```

Configuracao opcional:

```zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
```

### zsh-syntax-highlighting

Colore comandos validos, invalidos, strings, paths e outras partes da linha de comando.

Carregado no final do `~/.zshrc`:

```zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

Esse plugin deve ficar perto do final do arquivo.

### zsh-completions

Adiciona completions extras para varias ferramentas.

Configuracao no `~/.zshrc`:

```zsh
fpath=(/opt/homebrew/share/zsh-completions $fpath)
autoload -Uz compinit
compinit
```

Se aparecer aviso de `insecure directories`, rode:

```zsh
compaudit
chmod go-w /opt/homebrew/share
chmod -R go-w /opt/homebrew/share/zsh
chmod -R go-w /opt/homebrew/share/zsh-completions
```

## Oh My Zsh

O bloco gerenciado e compativel com Oh My Zsh quando `~/.oh-my-zsh` existe:

```zsh
export ZSH="$HOME/.oh-my-zsh"
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME=""
  plugins=(git)
  source "$ZSH/oh-my-zsh.sh"
fi
```

O shell funciona normalmente mesmo sem Oh My Zsh.

Para instalar Oh My Zsh:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Depois, confira se o instalador nao sobrescreveu seu `~/.zshrc`. Se sobrescrever, restaure um backup ou reaplique as secoes deste guia.

## Lazy-load de nvm e sdkman

Antes, `nvm` e `sdkman` carregavam em toda abertura do terminal. Agora eles carregam sob demanda, quando voce chama comandos relacionados.

### nvm

Carregado quando voce usa:

```zsh
nvm
node
npm
npx
corepack
yarn
pnpm
```

Isso deixa a abertura do terminal mais rapida.

### sdkman

Carregado quando voce usa:

```zsh
sdk
java
javac
jshell
jar
mvn
gradle
```

Isso evita pagar o custo do SDKMAN em todo terminal novo.

## Aliases configurados

```zsh
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat'

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
```

## Comandos de verificacao

Ver se o `.zshrc` tem erro de sintaxe:

```zsh
zsh -n ~/.zshrc
```

Medir tempo de abertura:

```zsh
time zsh -i -c exit
```

Ver ferramentas instaladas:

```zsh
command -v starship zoxide fzf eza bat delta lazygit atuin direnv fd
```

Ver configuracao do Git:

```zsh
git config --global --get-regexp 'core.pager|interactive.diffFilter|delta|merge.conflictstyle|diff.colorMoved'
```

## Solucao de problemas

### Icones aparecem como quadradinhos

Configure uma Nerd Font no terminal.

Reinstalar fonte:

```bash
brew reinstall --cask font-jetbrains-mono-nerd-font
```

Depois selecione `JetBrainsMono Nerd Font Mono` nas preferencias do terminal.

### Aviso `zsh compinit: insecure directories`

Verifique:

```zsh
compaudit
```

Corrija permissoes:

```zsh
chmod go-w /opt/homebrew/share
chmod -R go-w /opt/homebrew/share/zsh
chmod -R go-w /opt/homebrew/share/zsh-completions
```

### Quero voltar ao zshrc anterior

Escolha um backup criado pelo instalador e restaure:

```zsh
cp ~/.zshrc.backup.YYYYMMDD-HHMMSS ~/.zshrc
```

Abra uma nova aba do terminal.

### Quero desativar os icones no ls

Edite `~/.zshrc` e troque:

```zsh
alias ls='eza --icons --group-directories-first'
```

por:

```zsh
alias ls='eza --group-directories-first'
```

Repita para `ll`, `la` e `tree`.

### Quero desativar o atuin

Comente esta linha no `~/.zshrc`:

```zsh
eval "$(atuin init zsh --disable-up-arrow)"
```

### Quero desativar o starship

Comente esta linha no `~/.zshrc`:

```zsh
eval "$(starship init zsh)"
```

## Fluxo recomendado

Comandos para experimentar no dia a dia:

```zsh
ll
z nome-de-uma-pasta
Ctrl+R
lg
git diff
fd termo
cat arquivo
```

Depois de alguns dias, `zoxide` e `atuin` ficam mais uteis porque aprendem seus diretorios e historico reais.
