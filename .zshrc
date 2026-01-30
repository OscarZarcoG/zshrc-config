# PERFORMANCE
skip_global_compinit=1
export KEYTIMEOUT=1

# HISTORY
HISTFILE=$HOME/.local/share/zsh/history
HISTSIZE=50000
SAVEHIST=50000
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_verify
setopt extended_history

# NAVIGATION
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt correct

# COMPLETION SYSTEM
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

fpath=(~/.config/zsh/zsh-completions $fpath)

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# COLORS
autoload -Uz colors && colors
setopt prompt_subst

# GIT INFO
git_info() {
  local branch dirty ahead behind
  if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      dirty=" %F{red}✗%f"
    else
      dirty=" %F{green}✓%f"
    fi
    local ahead_behind=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    if [[ -n $ahead_behind ]]; then
      ahead=$(echo $ahead_behind | awk '{print $1}')
      behind=$(echo $ahead_behind | awk '{print $2}')
      [[ $ahead -gt 0 ]] && ahead=" %F{cyan}↑$ahead%f" || ahead=""
      [[ $behind -gt 0 ]] && behind=" %F{magenta}↓$behind%f" || behind=""
    fi
    echo " %F{yellow}($branch$dirty$ahead$behind)%f"
  fi
}

# VENV INFO
venv_info() {
  [[ -n $VIRTUAL_ENV ]] && echo " %F{green}($(basename $VIRTUAL_ENV))%f"
}

# EXIT STATUS
exit_status() {
  echo "%(?.%F{green}➜%f.%F{red}➜%f)"
}

# EXECUTION TIME
preexec() {
  timer=$(($(date +%s%N)/1000000))
}

precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%N)/1000000))
    elapsed=$(($now-$timer))
    if [ $elapsed -gt 5000 ]; then
      export RPROMPT="%F{yellow}⏱ ${elapsed}ms%f"
    else
      export RPROMPT=""
    fi
    unset timer
  fi
}

# PROMPT
PROMPT='
%F{blue}╭─%f %F{cyan}%n@%m%f %F{magenta}%~%f$(git_info)$(venv_info)
%F{blue}╰─%f $(exit_status) '

# AUTO-INSTALL PLUGINS
ZSH_PLUGIN_DIR="${HOME}/.config/zsh"
ensure_plugin() {
  local plugin_name=$1
  local plugin_url=$2
  local plugin_path="${ZSH_PLUGIN_DIR}/${plugin_name}"
  if [[ ! -d "$plugin_path" ]]; then
    echo "Instalando ${plugin_name}..."
    git clone --depth=1 "$plugin_url" "$plugin_path"
  fi
}

ensure_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
ensure_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
ensure_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"

# LOAD PLUGINS
source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ALIASES - SISTEMA
alias c='clear'
alias cls='clear'
alias h='history'
alias hg='history | grep'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# LISTADO
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -lAhF'
alias lt='ls -lhtF'
alias lz='ls -lShF'
alias l='ls -CF'
alias tree='tree -C'

# GREP
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# GIT
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -av'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate --all'
alias glo='git log --oneline --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
alias greset='git reset --hard HEAD'
alias gclean='git clean -fd'

# DOCKER
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcb='docker compose build'
alias dcl='docker compose logs -f'
alias dce='docker compose exec'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -af'
alias dstop='docker stop $(docker ps -q)'

# PYTHON
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias act='source .venv/bin/activate'
alias deact='deactivate'
alias pipi='pip install'
alias pipu='pip install --upgrade'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'
alias pytest='python -m pytest'
alias pym='python manage.py'
alias pyms='python manage.py runserver'
alias pymm='python manage.py migrate'
alias pymmk='python manage.py makemigrations'

# NPM
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nrd='npm run dev'

# MONITORING
alias ports='netstat -tulanp'
alias meminfo='free -h'
alias diskinfo='df -h'
alias cpuinfo='lscpu'
alias myip='curl ifconfig.me'

# FUNCIONES
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' no puede ser extraído" ;;
    esac
  else
    echo "'$1' no es un archivo válido"
  fi
}

ff() { find . -type f -iname "*$1*"; }
fd() { find . -type d -iname "*$1*"; }
backup() { cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}; }
gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

pynew() {
  mkdir -p "$1" && cd "$1"
  python3 -m venv .venv
  source .venv/bin/activate
  pip install --upgrade pip
  echo "Proyecto '$1' creado"
}

dcleanup() { docker system prune -af --volumes; }

sysinfo() {
  echo "=== SYSTEM INFO ==="
  echo "OS: $(uname -s)"
  echo "Kernel: $(uname -r)"
  echo "Hostname: $(hostname)"
  echo "CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
  echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
  echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
  echo "Uptime: $(uptime -p)"
}

# KEY BINDINGS
bindkey -e
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ENVIRONMENT
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-R -F -X'
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34'
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# LOAD LOCAL CUSTOMIZATIONS
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# NVM CONFIGURATION
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"