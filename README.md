# ZSH Config 

## Características

- Prompt multi-línea con información contextual
- Integración con Git (branch, estado, commits adelante/atrás)
- Indicador de entorno virtual Python
- Tiempo de ejecución para comandos largos
- Historial de 50,000 comandos con búsqueda inteligente
- Sistema de completado con caché
- Auto-instalación de plugins
- 60 alias para Git, Docker, Python y NPM
- 10 funciones útiles
- Optimizado para rendimiento

## Instalación

### Requisitos

```bash
# Ubuntu/Debian
sudo apt install zsh git

# Fedora
sudo dnf install zsh git

# Arch
sudo pacman -S zsh git

# macOS
brew install zsh git
```

### Setup

```bash
# Backup
cp ~/.zshrc ~/.zshrc.backup

# Descargar
curl -o ~/.zshrc https://raw.githubusercontent.com/OscarZarcoG/zshrc-config/main/.zshrc

# O clonar
git clone https://github.com/OscarZarcoG/zshrc-config.git
cd zshrc-config
cp .zshrc ~/.zshrc

# Crear directorios
mkdir -p ~/.config/zsh ~/.local/share/zsh ~/.cache/zsh/completion

# Recargar
source ~/.zshrc
```

Los plugins se instalan automáticamente.

Opcional - Zsh como shell por defecto:
```bash
chsh -s $(which zsh)
```

## Atajos de teclado

- `Ctrl + R` - Búsqueda en historial (atrás)
- `Ctrl + S` - Búsqueda en historial (adelante)
- `Ctrl + →` - Avanzar palabra
- `Ctrl + ←` - Retroceder palabra
- `Ctrl + X, Ctrl + E` - Editar comando en editor
- `!!` - Repetir último comando
- `!$` - Último argumento del comando anterior

## Alias Sistema

```bash
c, cls          # clear
..              # cd ..
...             # cd ../..
....            # cd ../../..
-               # cd -
ll              # ls -lhF
la              # ls -lAhF
lt              # ls -lhtF (por fecha)
lz              # ls -lShF (por tamaño)
h               # history
hg palabra      # history | grep
```

## Alias Git

```bash
g               # git
gs              # git status -sb
gb              # git branch
gba             # git branch -a
gbd rama        # git branch -d
ga archivo      # git add
gaa             # git add --all
gc              # git commit -v
gcm "msg"       # git commit -m
gca             # git commit -av
gcam "msg"      # git commit -am
gco rama        # git checkout
gcb rama        # git checkout -b
gf              # git fetch
gpl             # git pull
gp              # git push
gl              # git log --oneline --graph --decorate --all
glo             # git log --oneline --decorate
gd              # git diff
gds             # git diff --staged
gst             # git stash
gstp            # git stash pop
greset          # git reset --hard HEAD
gclean          # git clean -fd
```

## Alias Docker

```bash
d               # docker
dc              # docker compose
dcu             # docker compose up
dcud            # docker compose up -d
dcd             # docker compose down
dcr             # docker compose restart
dcb             # docker compose build
dcl             # docker compose logs -f
dce srv sh      # docker compose exec srv sh
dps             # docker ps
dpsa            # docker ps -a
di              # docker images
drm             # docker rm
drmi            # docker rmi
dprune          # docker system prune -af
dstop           # docker stop $(docker ps -q)
```

## Alias Python

```bash
py              # python3
pip             # pip3
venv            # python3 -m venv .venv
act             # source .venv/bin/activate
deact           # deactivate
pipi pkg        # pip install
pipu pkg        # pip install --upgrade
pipr            # pip install -r requirements.txt
pipf            # pip freeze > requirements.txt
pym             # python manage.py
pyms            # python manage.py runserver
pymm            # python manage.py migrate
pymmk           # python manage.py makemigrations
pytest          # python -m pytest
```

## Alias NPM

```bash
ni              # npm install
nid             # npm install --save-dev
nig             # npm install -g
nr script       # npm run
ns              # npm start
nt              # npm test
nb              # npm run build
nrd             # npm run dev
```

## Funciones

### mkcd
```bash
mkcd proyecto
# mkdir -p proyecto && cd proyecto
```

### extract
```bash
extract archivo.tar.gz
extract backup.zip
# Detecta y extrae automáticamente
```

### ff / fd
```bash
ff config           # Buscar archivos
fd src              # Buscar directorios
```

### backup
```bash
backup config.json
# Crea: config.json.backup-20250130-143052
```

### gcl
```bash
gcl https://github.com/user/repo.git
# Clone y cd al directorio
```

### pynew
```bash
pynew proyecto
# Crea dir, venv, activa y actualiza pip
```

### dcleanup
```bash
dcleanup
# Limpia Docker completamente
```

### sysinfo
```bash
sysinfo
# Info del sistema
```

## Personalización

### Config local
Crea `~/.zshrc.local`:
```bash
export MI_VAR="valor"
alias custom='comando'
export PATH="$HOME/bin:$PATH"
```

### Cambiar colores
Edita en `.zshrc`:
```bash
PROMPT='
%F{blue}╭─%f %F{cyan}%n@%m%f %F{magenta}%~%f$(git_info)$(venv_info)
%F{blue}╰─%f $(exit_status) '
```

Colores: blue, cyan, magenta, green, yellow, red, white, black

### Prompt simple
```bash
PROMPT='%F{cyan}%~%f$(git_info) %F{green}➜%f '
```

## Tips

### Comando secreto
```bash
 comando
# Espacio inicial = no se guarda en historial
```

### Auto cd
```bash
/var/log
# Equivale a: cd /var/log
```

### Expansión llaves
```bash
mkdir -p proyecto/{src,tests,docs}
touch file.{js,css,html}
cp file.txt{,.bak}
```

### Sustituir comando
```bash
git push origin master
^master^main^
# Ejecuta: git push origin main
```

### Múltiples comandos
```bash
cmd1 && cmd2 && cmd3    # Para si falla
cmd1 ; cmd2 ; cmd3      # Continúa siempre
cmd1 || cmd2            # Solo si falla cmd1
```

### Redirección
```bash
cmd > file.txt          # Sobrescribir
cmd >> file.txt         # Agregar
cmd 2> err.txt          # Solo errores
cmd &> all.txt          # Todo
cmd > /dev/null 2>&1    # Descartar
```

### Directorios visitados
```bash
cd /ruta1
cd /ruta2
cd /ruta3
dirs -v                 # Ver stack
cd ~2                   # Ir a posición 2
```

## Troubleshooting

### Plugins no cargan
```bash
rm -rf ~/.config/zsh/zsh-*
source ~/.zshrc
```

### Completado lento
```bash
rm -rf ~/.zcompdump* ~/.cache/zsh/completion/*
source ~/.zshrc
```

### Terminal lenta
Comenta en `.zshrc` las líneas de `ahead_behind` en `git_info()`

### Restaurar config
```bash
cp ~/.zshrc.backup ~/.zshrc
source ~/.zshrc
```

## Plugins

- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-completions

Se instalan automáticamente.

## Estructura

```
~/.config/zsh/              # Plugins
~/.local/share/zsh/         # Historial
~/.cache/zsh/completion/    # Caché
~/.zshrc                    # Config principal
~/.zshrc.local              # Config personal
```

## Links

- [Zsh Docs](https://zsh.sourceforge.io/Doc/)
- [Zsh Lovers](https://grml.org/zsh/zsh-lovers.html)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
