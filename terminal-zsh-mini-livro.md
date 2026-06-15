# Mini livro: terminal zsh moderno

Este material e um guia de estudo e pratica para as ferramentas usadas neste setup de terminal zsh.

O objetivo nao e decorar comandos. O objetivo e criar memoria muscular para navegar, buscar, ler arquivos, trabalhar com Git e ajustar ambientes de projeto com menos atrito.

## Como estudar

Use este mini livro em ciclos curtos:

1. Leia um capitulo.
2. Rode todos os comandos de pratica.
3. Repita os exercicios em um projeto real.
4. Anote os comandos que voce realmente usou.

Uma boa rotina:

```zsh
15 min por dia durante 7 dias
1 ferramenta principal por dia
1 projeto real como campo de pratica
```

Antes de comecar, confirme que as ferramentas existem:

```zsh
command -v zsh starship eza bat zoxide fzf atuin direnv fd rg delta lazygit nvim
```

Se algum comando nao aparecer, consulte `terminal-zsh-guide.md` e revise a instalacao.

## Mapa das ferramentas

| Ferramenta | Funcao principal |
| --- | --- |
| `zsh` | Shell interativo usado no terminal |
| `starship` | Prompt moderno e rapido |
| `eza` | Substituto moderno para `ls` |
| `bat` | Substituto moderno para `cat`, com syntax highlighting |
| `zoxide` | Navegacao inteligente entre diretorios |
| `fzf` | Busca fuzzy interativa |
| `atuin` | Historico de comandos pesquisavel |
| `direnv` | Variaveis de ambiente por projeto |
| `fd` | Busca de arquivos, alternativa ao `find` |
| `ripgrep` / `rg` | Busca de texto dentro de arquivos |
| `git-delta` / `delta` | Visualizacao melhor de diffs Git |
| `lazygit` | Interface terminal para Git |
| `neovim` / `nvim` | Editor moderno dentro do terminal |
| `LazyVim` | Configuracao pronta do Neovim instalada em `~/.config/nvim` |
| `zsh-autosuggestions` | Sugestoes enquanto voce digita |
| `zsh-syntax-highlighting` | Cores para comandos validos e invalidos |
| `zsh-completions` | Completions extras para o shell |

## Capitulo 1: mentalidade de terminal

Um terminal eficiente combina quatro movimentos:

1. Navegar ate o lugar certo.
2. Encontrar o arquivo ou texto certo.
3. Inspecionar conteudo rapidamente.
4. Executar uma acao com confianca.

Neste setup, essas etapas ficam assim:

```zsh
z projeto
fd termo
rg "texto"
bat arquivo
lg
```

Pratica:

```zsh
pwd
ll
z ..
fd md
rg "zsh"
```

Desafio:

Encontre todos os arquivos Markdown deste repositorio e abra um deles com `bat`.

## Capitulo 2: zsh

`zsh` e o shell. Ele interpreta os comandos digitados, expande variaveis, executa programas e aplica aliases.

Comandos essenciais:

```zsh
echo $SHELL
echo $PATH
alias
setopt
zsh -n ~/.zshrc
```

Conceitos importantes:

| Conceito | Exemplo | O que significa |
| --- | --- | --- |
| variavel | `HOME` | valor usado pelo shell |
| PATH | `$PATH` | lista de pastas onde comandos sao procurados |
| alias | `ll='eza -lah'` | atalho para comando maior |
| funcao | `nome() { ... }` | bloco reutilizavel de shell |
| completion | `Tab` | preenchimento automatico |

Pratica:

```zsh
echo $HOME
echo $PATH
type ll
type z
type git
```

Se voce alterou `~/.zshrc`, valide antes de abrir outro terminal:

```zsh
zsh -n ~/.zshrc
```

## Capitulo 3: starship

`starship` controla o prompt. Ele mostra informacoes como diretorio atual, branch Git, status do comando anterior e versoes de linguagens.

Verifique:

```zsh
starship --version
starship explain
```

Arquivo de configuracao opcional:

```zsh
mkdir -p ~/.config
touch ~/.config/starship.toml
```

Exemplo simples:

```toml
add_newline = true

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "git "

[character]
success_symbol = "[>](bold green)"
error_symbol = "[>](bold red)"
```

Pratica:

```zsh
cd ~
mkdir -p /tmp/starship-pratica
cd /tmp/starship-pratica
git init
touch README.md
git status
false
true
```

Observe como o prompt muda conforme o diretorio, o Git e o ultimo comando.

## Capitulo 4: eza

`eza` substitui `ls` com melhor formatacao, icones e organizacao.

Aliases configurados pelo setup:

```zsh
ls
ll
la
tree
```

Comandos uteis:

```zsh
eza
eza -la
eza -lah --icons --group-directories-first
eza --tree --level=2
eza --git
```

Pratica:

```zsh
ls
ll
la
tree
eza --tree --level=2
```

Desafio:

Liste a estrutura de um repositorio em formato de arvore com no maximo dois niveis.

## Capitulo 5: bat

`bat` e uma versao melhorada do `cat`. Ele mostra cores, numeros de linha e integra com pager.

Alias configurado pelo setup:

```zsh
cat='bat'
```

Comandos uteis:

```zsh
bat terminal-zsh-guide.md
bat -n terminal-zsh-guide.md
bat --plain terminal-zsh-guide.md
bat --style=numbers,changes terminal-zsh-guide.md
```

Pratica:

```zsh
bat terminal-zsh-guide.md
bat terminal-zsh-setup/install-terminal-zsh-setup.sh
bat --plain terminal-zsh-setup/Brewfile
```

Quando usar:

| Use | Quando |
| --- | --- |
| `bat arquivo` | leitura humana |
| `bat --plain arquivo` | saida simples |
| `sed -n '1,80p' arquivo` | trecho especifico |
| `cat arquivo` | neste setup, chama `bat` |

## Capitulo 6: zoxide

`zoxide` aprende os diretorios que voce usa e permite navegar por nome aproximado.

Comandos:

```zsh
z nome
z github
z setup
z -
zi
```

`zi` abre selecao interativa quando ha varias opcoes.

Pratica:

```zsh
cd ~
cd /tmp
cd caminho/do/seu/projeto
cd ~
z projeto
z repositorio
z -
```

Ver dados aprendidos:

```zsh
zoxide query projeto
zoxide query -l
```

Desafio:

Durante uma semana, pare de usar `cd` para diretorios frequentes. Use `z`.

## Capitulo 7: fzf

`fzf` e uma busca fuzzy interativa. Ele encontra itens mesmo quando voce digita partes incompletas.

Atalhos comuns:

| Atalho | Acao |
| --- | --- |
| `Ctrl+R` | buscar historico |
| `Ctrl+T` | buscar arquivos |
| `Alt+C` | buscar diretorios |

Comandos diretos:

```zsh
fzf
fd | fzf
rg --files | fzf
```

Pratica:

```zsh
rg --files | fzf
fd md | fzf
```

Abrir arquivo escolhido:

```zsh
bat "$(rg --files | fzf)"
```

Desafio:

Use `fzf` para escolher um arquivo `.sh` e abrir com `bat`.

## Capitulo 8: atuin

`atuin` melhora o historico do shell. Ele permite buscar comandos antigos com contexto.

Comandos:

```zsh
atuin search git
atuin search zsh
atuin stats
atuin history list
```

Atalho principal:

```text
Ctrl+R
```

Pratica:

```zsh
echo pratica-atuin
ls
git status
atuin search pratica-atuin
atuin search "git status"
```

Boas praticas:

| Situacao | Acao |
| --- | --- |
| repetir comando antigo | `Ctrl+R` |
| descobrir padroes de uso | `atuin stats` |
| buscar por palavra | `atuin search termo` |

Evite gravar segredos no historico. Se digitou token ou senha por acidente, remova do historico conforme a documentacao do `atuin`.

## Capitulo 9: direnv

`direnv` carrega variaveis de ambiente automaticamente por projeto.

Fluxo basico:

```zsh
echo 'export APP_ENV=dev' > .envrc
direnv allow
echo $APP_ENV
```

Quando voce sai da pasta, a variavel deixa de valer.

Pratica segura:

```zsh
mkdir -p /tmp/direnv-pratica
cd /tmp/direnv-pratica
echo 'export PROJETO=direnv-pratica' > .envrc
direnv allow
echo $PROJETO
cd ..
echo $PROJETO
```

Regra importante:

```zsh
direnv allow
```

Esse comando autoriza a execucao de `.envrc`. Use apenas em projetos confiaveis, porque `.envrc` e codigo shell.

Desafio:

Crie um `.envrc` que define `JAVA_HOME`, `NODE_ENV` ou outra variavel usada em um projeto real.

## Capitulo 10: fd

`fd` busca arquivos e diretorios. Ele e mais simples que `find`.

Comandos:

```zsh
fd md
fd sh
fd Brewfile
fd '\.md$'
fd -t f
fd -t d
fd -H
```

Opcoes comuns:

| Opcao | Significado |
| --- | --- |
| `-t f` | somente arquivos |
| `-t d` | somente diretorios |
| `-H` | inclui arquivos ocultos |
| `-e md` | filtra por extensao |
| `--exclude nome` | ignora caminho |

Pratica:

```zsh
fd -e md
fd -e sh terminal-zsh-setup
fd -t f Brewfile
```

Desafio:

Liste somente scripts shell dentro de `terminal-zsh-setup`.

## Capitulo 11: ripgrep

`ripgrep`, chamado pelo comando `rg`, busca texto dentro dos arquivos.

Comandos:

```zsh
rg "starship"
rg "git config"
rg -n "alias"
rg -i "ubuntu"
rg --files
rg --files -g "*.md"
```

Opcoes comuns:

| Opcao | Significado |
| --- | --- |
| `-n` | mostra numero da linha |
| `-i` | ignora maiusculas/minusculas |
| `-C 2` | mostra contexto antes e depois |
| `--files` | lista arquivos considerados |
| `-g "*.md"` | filtra glob |

Pratica:

```zsh
rg -n "zoxide"
rg -n "alias" terminal-zsh-guide.md
rg -C 2 "direnv"
rg --files -g "*.sh"
```

Desafio:

Encontre todos os pontos onde os scripts mexem em Git global.

## Capitulo 12: git-delta

`delta` melhora a visualizacao de diffs do Git.

Configuracao usada pelo setup:

```zsh
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global merge.conflictstyle zdiff3
git config --global diff.colorMoved default
```

Comandos onde voce vai perceber o `delta`:

```zsh
git diff
git show
git log -p
```

Pratica:

```zsh
mkdir -p /tmp/delta-pratica
cd /tmp/delta-pratica
git init
printf 'linha 1\nlinha 2\n' > exemplo.txt
git add exemplo.txt
git commit -m "inicio"
printf 'linha 1\nlinha 2 alterada\nlinha 3\n' > exemplo.txt
git diff
```

Se quiser comparar o comportamento:

```zsh
git --no-pager diff
```

## Capitulo 13: lazygit

`lazygit` e uma interface terminal para Git.

Abrir:

```zsh
lg
```

Atalhos basicos:

| Tecla | Acao |
| --- | --- |
| `?` | ajuda |
| `q` | sair |
| `space` | selecionar arquivo ou hunk |
| `c` | commit |
| `p` | push/pull dependendo do painel |
| `Tab` | trocar de painel |

Pratica:

```zsh
mkdir -p /tmp/lazygit-pratica
cd /tmp/lazygit-pratica
git init
printf '# Teste\n' > README.md
lg
```

Dentro do `lazygit`, selecione o arquivo, faca stage, crie um commit e saia.

Desafio:

Use `lazygit` para fazer stage parcial de um arquivo com duas mudancas.

## Capitulo 14: Neovim e LazyVim

`Neovim`, aberto pelo comando `nvim`, e um editor de texto dentro do terminal. Neste setup ele foi instalado com `LazyVim`, uma configuracao moderna que ja traz explorador de arquivos, busca fuzzy, LSP, formatacao, Git, tema e atalhos organizados.

O objetivo inicial nao e substituir IntelliJ, VS Code, Cursor ou Antigravity. O objetivo e ganhar fluidez para editar arquivos, configs, scripts, Markdown e commits diretamente do terminal.

Verifique:

```zsh
nvim --version
test -d ~/.config/nvim && echo "LazyVim configurado"
```

Abrir um arquivo:

```zsh
nvim README.md
```

Abrir um projeto:

```zsh
cd /Users/cristianmathias/_dev/_github/terminal-zsh-setup
nvim .
```

### Modos do Vim

O Neovim tem modos. Essa e a primeira virada de chave.

| Modo | Para que serve | Como entrar | Como sair |
| --- | --- | --- | --- |
| normal | navegar e executar comandos | padrao ao abrir | `Esc` |
| insert | escrever texto | `i`, `a`, `o`, `O` | `Esc` |
| command | salvar, sair, executar comandos | `:` | `Enter` ou `Esc` |
| visual | selecionar texto | `v`, `V` | `Esc` |

Ciclo basico:

```text
i -> escreve -> Esc -> :w
```

Comandos essenciais:

| Tecla/comando | Acao |
| --- | --- |
| `i` | entra em modo de insercao antes do cursor |
| `a` | entra em modo de insercao depois do cursor |
| `o` | cria linha abaixo e entra escrevendo |
| `O` | cria linha acima e entra escrevendo |
| `Esc` | volta ao modo normal |
| `:w` | salva |
| `:q` | sai |
| `:wq` | salva e sai |
| `:q!` | sai sem salvar |
| `u` | desfaz |
| `Ctrl+r` | refaz |

Pratica 1: editar um arquivo temporario.

```zsh
mkdir -p /tmp/nvim-pratica
cd /tmp/nvim-pratica
nvim anotacoes.md
```

Dentro do Neovim:

```text
i
# Minhas anotacoes

Hoje eu testei Neovim com LazyVim.
Esc
:w
:q
```

Confira fora do Neovim:

```zsh
bat anotacoes.md
```

### Navegacao basica

No modo normal:

| Tecla | Acao |
| --- | --- |
| `h` | esquerda |
| `j` | baixo |
| `k` | cima |
| `l` | direita |
| `gg` | inicio do arquivo |
| `G` | fim do arquivo |
| `w` | proxima palavra |
| `b` | palavra anterior |
| `0` | inicio da linha |
| `$` | fim da linha |

Voce tambem pode usar as setas no comeco. O ganho vem aos poucos quando `hjkl` entra na memoria muscular.

### Atalhos do LazyVim

No LazyVim, a tecla principal e `Space`. Pressione `Space` e espere um instante: o menu de atalhos aparece.

Atalhos uteis:

| Atalho | Acao |
| --- | --- |
| `Space e` | abre/fecha explorador de arquivos |
| `Space ff` | busca arquivos do projeto |
| `Space fg` | busca texto no projeto |
| `Space fr` | arquivos recentes |
| `Space gg` | abre LazyGit integrado |
| `Space /` | busca texto no buffer atual |
| `Space u` | opcoes visuais e toggles |
| `Space c a` | code action quando ha LSP |
| `Space c f` | formatar arquivo |

Pratica 2: abrir arquivo por busca.

```zsh
cd /Users/cristianmathias/_dev/_github/terminal-zsh-setup
nvim .
```

Dentro do Neovim:

```text
Space ff
```

Digite parte do nome:

```text
install-terminal
```

Pressione `Enter` para abrir.

### Editar texto com seguranca

Comandos comuns no modo normal:

| Comando | Acao |
| --- | --- |
| `dd` | apaga linha |
| `yy` | copia linha |
| `p` | cola depois |
| `x` | apaga caractere |
| `ciw` | troca palavra inteira |
| `di"` | apaga conteudo dentro de aspas |
| `.` | repete a ultima edicao |

Pratica 3: editar uma linha.

```zsh
cd /tmp/nvim-pratica
nvim anotacoes.md
```

Dentro do arquivo:

1. Va ate a linha que voce escreveu.
2. Pressione `o`.
3. Escreva outra linha.
4. Pressione `Esc`.
5. Salve com `:w`.

### Buscar dentro do arquivo

No modo normal:

```text
/palavra
```

Depois:

| Tecla | Acao |
| --- | --- |
| `n` | proxima ocorrencia |
| `N` | ocorrencia anterior |

Pratica:

```text
/LazyVim
n
N
```

### Git dentro do Neovim

Como o setup ja tem `lazygit`, o LazyVim consegue abrir Git sem sair do editor:

```text
Space gg
```

Fluxo pratico:

```zsh
cd /Users/cristianmathias/_dev/_github/terminal-zsh-setup
nvim .
```

Dentro do Neovim:

1. Abra um arquivo com `Space ff`.
2. Faca uma pequena edicao.
3. Salve com `:w`.
4. Abra Git com `Space gg`.
5. Revise a mudanca.
6. Saia do LazyGit com `q`.

### LSP, formatacao e Mason

LazyVim usa `Mason` para gerenciar servidores de linguagem, formatadores e ferramentas auxiliares.

Abrir Mason:

```text
:Mason
```

Abrir gerenciador de plugins:

```text
:Lazy
```

Formatar arquivo:

```text
Space c f
```

Ferramentas instaladas por este setup que ajudam o LazyVim:

| Ferramenta | Uso |
| --- | --- |
| `ripgrep` | busca de texto |
| `fd` | busca de arquivos |
| `lazygit` | Git integrado |
| `tree-sitter` | parsing/syntax highlighting |
| `luarocks` | dependencias Lua |
| `stylua` | formatacao Lua |
| `shellcheck` | diagnostico Shell |
| `shfmt` | formatacao Shell |

### Onde ficam as configuracoes

Arquivos principais:

```text
~/.config/nvim/
~/.config/nvim/lua/config/
~/.config/nvim/lua/plugins/
```

Regra de ouro: use o LazyVim como esta por alguns dias antes de customizar. Primeiro ganhe memoria muscular; depois personalize.

Para recriar a configuracao pelo instalador deste repositorio:

```zsh
./terminal-zsh-setup/install-terminal-zsh-setup.sh --reinstall-neovim
```

Isso faz backup da configuracao atual antes de instalar novamente.

### Sobre IA e Neovim

Mesmo com ferramentas como Cursor, Antigravity e IntelliJ com IA, Neovim ainda faz sentido como editor de terminal:

- abre rapido;
- funciona bem em projetos pequenos e arquivos de configuracao;
- integra com Git e busca sem sair do terminal;
- ajuda a entender melhor edicao modal;
- e otimo para ajustes rapidos enquanto voce esta em uma sessao de shell.

Use Neovim como ferramenta complementar. Para projetos grandes, IntelliJ, VS Code, Cursor e Antigravity continuam excelentes.

Desafio:

Abra este repositorio com `nvim .`, encontre `terminal-zsh-setup/install-terminal-zsh-setup.sh` com `Space ff`, procure `install_neovim_config` com `/install_neovim_config`, abra `Space gg` e revise as mudancas atuais.

## Capitulo 15: zsh-autosuggestions

`zsh-autosuggestions` mostra sugestoes em cinza enquanto voce digita, baseadas no historico.

Como praticar:

```zsh
git status
git status -sb
```

Depois digite apenas:

```zsh
git sta
```

Se aparecer uma sugestao, aceite com:

```text
Seta direita
```

ou:

```text
End
```

Regra pratica:

Use sugestoes para comandos repetitivos, mas leia antes de aceitar. Um comando antigo pode nao ser adequado no diretorio atual.

## Capitulo 16: zsh-syntax-highlighting

`zsh-syntax-highlighting` colore comandos enquanto voce digita.

O que observar:

| Cor/estado | Ideia |
| --- | --- |
| comando valido | o shell encontrou o comando |
| comando invalido | provavelmente erro de digitacao |
| string | argumento textual |
| path | caminho reconhecido |

Pratica:

Digite sem executar:

```zsh
git status
gti status
bat terminal-zsh-guide.md
bat arquivo-que-nao-existe.md
```

Corrija antes de pressionar Enter.

## Capitulo 17: zsh-completions

`zsh-completions` adiciona completions para ferramentas do terminal.

Tecla principal:

```text
Tab
```

Pratica:

```zsh
git <Tab>
brew <Tab>
ssh <Tab>
cd <Tab>
```

Se houver varias opcoes, pressione `Tab` novamente ou navegue pelo menu de completions.

Diagnostico:

```zsh
compaudit
```

Se aparecer aviso de diretorios inseguros, consulte `terminal-zsh-guide.md`.

## Capitulo 18: nvm e sdkman em lazy-load

Este setup nao instala necessariamente `nvm` ou `sdkman`, mas prepara funcoes para carrega-los sob demanda se eles existirem.

Comandos que disparam `nvm`:

```zsh
nvm
node
npm
npx
corepack
yarn
pnpm
```

Comandos que disparam `sdkman`:

```zsh
sdk
java
javac
jshell
jar
mvn
gradle
```

Verifique:

```zsh
type node
type npm
type java
type gradle
```

O ganho esperado e abrir o terminal mais rapido, carregando essas ferramentas so quando forem usadas.

## Capitulo 19: fluxos reais

### Fluxo 1: entrar em projeto e localizar arquivo

```zsh
z projeto
ll
fd -e md
bat "$(fd -e md | fzf)"
```

### Fluxo 2: investigar onde uma configuracao e definida

```zsh
rg -n "git config"
rg -n "zoxide"
rg -C 3 "compinit"
```

### Fluxo 3: revisar mudancas Git

```zsh
git status -sb
git diff
lg
```

### Fluxo 4: configurar ambiente local de projeto

```zsh
printf 'export APP_ENV=development\n' > .envrc
direnv allow
echo $APP_ENV
```

### Fluxo 5: repetir comando antigo

```zsh
Ctrl+R
```

Busque parte do comando, confirme se esta correto e execute.

## Plano de pratica de 8 dias

### Dia 1: navegacao e listagem

Foco:

```zsh
z
ll
tree
```

Tarefa:

Use `zoxide` para entrar em tres diretorios frequentes e `eza` para entender suas estruturas.

### Dia 2: leitura de arquivos

Foco:

```zsh
bat
fd
```

Tarefa:

Encontre cinco arquivos por extensao e leia todos com `bat`.

### Dia 3: busca de texto

Foco:

```zsh
rg
```

Tarefa:

Procure por configuracoes, aliases, imports ou funcoes em um projeto real.

### Dia 4: busca interativa

Foco:

```zsh
fzf
Ctrl+R
```

Tarefa:

Abra arquivos escolhidos via `fzf` e repita comandos antigos via `atuin`.

### Dia 5: Git visual

Foco:

```zsh
delta
lg
```

Tarefa:

Crie mudancas pequenas, revise com `git diff` e faca commit pelo `lazygit`.

### Dia 6: ambiente por projeto

Foco:

```zsh
direnv
```

Tarefa:

Crie um `.envrc` em um projeto de teste e valide entrada e saida de variaveis.

### Dia 7: edicao com Neovim

Foco:

```zsh
nvim
```

Tarefa:

Abra um projeto com `nvim .`, encontre um arquivo com `Space ff`, edite uma linha usando `i`, salve com `:w`, busque texto com `/` e abra Git com `Space gg`.

### Dia 8: consolidacao

Foco:

```zsh
z
fd
rg
bat
lg
nvim
```

Tarefa:

Resolva uma tarefa real usando o minimo possivel de navegacao manual.

## Exercicios finais

### Exercicio 1: mapa do projeto

Objetivo: entender rapidamente um repositorio.

```zsh
z projeto
tree
fd
rg --files
rg -n "brew"
```

Resposta esperada:

Voce deve conseguir explicar quais arquivos existem, quais scripts executam instalacao e quais pacotes fazem parte do setup.

### Exercicio 2: investigacao dirigida

Objetivo: encontrar onde uma ferramenta e configurada.

```zsh
rg -n "atuin"
rg -n "starship"
rg -n "direnv"
```

Resposta esperada:

Voce deve identificar a documentacao e o ponto exato do script que define cada configuracao no `.zshrc`.

### Exercicio 3: ambiente temporario

Objetivo: praticar `direnv` sem risco.

```zsh
mkdir -p /tmp/pratica-terminal
cd /tmp/pratica-terminal
printf 'export TREINO_TERMINAL=ativo\n' > .envrc
direnv allow
echo $TREINO_TERMINAL
cd ..
echo $TREINO_TERMINAL
```

Resposta esperada:

A variavel existe dentro do diretorio e some fora dele.

### Exercicio 4: Git completo

Objetivo: praticar `delta` e `lazygit`.

```zsh
mkdir -p /tmp/pratica-git-terminal
cd /tmp/pratica-git-terminal
git init
printf 'primeira linha\nsegunda linha\n' > app.txt
git add app.txt
git commit -m "inicio"
printf 'primeira linha\nsegunda linha alterada\nterceira linha\n' > app.txt
git diff
lg
```

Resposta esperada:

Voce deve conseguir revisar o diff, fazer stage e criar commit.

### Exercicio 5: edicao com Neovim

Objetivo: praticar o ciclo basico de edicao modal.

```zsh
mkdir -p /tmp/pratica-nvim
cd /tmp/pratica-nvim
nvim diario.md
```

Dentro do Neovim:

```text
i
# Diario de pratica

- Aprendi a entrar em modo insert.
- Aprendi a salvar com :w.
Esc
:w
:q
```

Depois confira:

```zsh
bat diario.md
```

Resposta esperada:

Voce deve conseguir criar, editar, salvar e sair de um arquivo sem se perder nos modos.

## Checklist de dominio

Marque quando conseguir fazer sem consultar:

- [ ] Entrar em um projeto com `z`.
- [ ] Listar arquivos com `ll`, `la` e `tree`.
- [ ] Abrir arquivos com `bat`.
- [ ] Encontrar arquivos com `fd`.
- [ ] Encontrar texto com `rg`.
- [ ] Escolher arquivo interativamente com `fzf`.
- [ ] Buscar comando antigo com `atuin` ou `Ctrl+R`.
- [ ] Criar e autorizar `.envrc` com `direnv`.
- [ ] Revisar diff com `delta`.
- [ ] Fazer stage e commit com `lazygit`.
- [ ] Abrir projeto com `nvim .`.
- [ ] Editar, salvar e sair de um arquivo no Neovim.
- [ ] Buscar arquivos no LazyVim com `Space ff`.
- [ ] Buscar texto no LazyVim com `Space fg`.
- [ ] Abrir LazyGit dentro do LazyVim com `Space gg`.
- [ ] Validar `~/.zshrc` com `zsh -n ~/.zshrc`.

## Referencia rapida

```zsh
# navegacao
z nome
z -
zi

# listagem
ll
la
tree
eza --tree --level=2

# leitura
bat arquivo
bat --plain arquivo

# busca de arquivos
fd termo
fd -e md
fd -t f

# busca de texto
rg "texto"
rg -n "texto"
rg -C 2 "texto"
rg --files

# fuzzy finder
fd | fzf
rg --files | fzf
bat "$(rg --files | fzf)"

# historico
atuin search termo
atuin stats

# ambiente
direnv allow
direnv reload

# git
git status -sb
git diff
lg

# neovim/lazyvim
nvim arquivo
nvim .
# dentro do nvim: i, Esc, :w, :q, Space ff, Space fg, Space gg

# verificacao
zsh -n ~/.zshrc
time zsh -i -c exit
```

## Proximo nivel

Depois de praticar o basico, personalize apenas o que gerar ganho real:

1. Ajuste `~/.config/starship.toml`.
2. Crie aliases proprios para fluxos repetidos.
3. Use `.envrc` em projetos com variaveis recorrentes.
4. Aprenda filtros de `rg` e `fd` com mais profundidade.
5. Use LazyVim por alguns dias antes de customizar `~/.config/nvim`.
6. Configure temas e atalhos do `lazygit` se voce usa Git todos os dias.

Evite configurar tudo de uma vez. Um terminal bom e aquele que voce consegue operar sem pensar demais.
