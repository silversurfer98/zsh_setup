#!/bin/bash

# Install some core packages
sudo apt install -y tmux zsh fontconfig


# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza


# get MS edit
msedit=$(curl -s https://api.github.com/repos/microsoft/edit/releases/latest | grep browser_download_url | grep x86_64-linux-gnu.tar.zst | awk 'NR==1 {gsub(/"/, "", $2); print $2}') && curl -LO $msedit
tar xvf edit* --directory $HOME/.local/bin
rm edit-*


# Install ripgrep
latest_url=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
  | grep browser_download_url \
  | grep 'amd64.deb' \
  | awk 'NR==1 {gsub(/"/, "", $2); print $2}') && curl -LO "$latest_url" && sudo dpkg -i rip*.deb && rm ripg*


# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y


# get and install firacode font
version=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \  | grep tag_name | awk '{gsub(/"/, "", $2); gsub(/,/, "", $2); print $2}') && \curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/$version/FiraCode.tar.xz && \mkdir -p ~/.fonts && \tar -xvf FiraCode.tar.xz --directory ~/.fonts && \fc-cache -fv
rm FiraCode.tar.xz


# Install fzf
latest_url=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest \
  | grep browser_download_url \
  | grep 'linux_amd64.tar.gz' \
  | awk 'NR==1 {gsub(/"/, "", $2); print $2}') && curl -LO $latest_url && sudo tar xvf fzf-* --directory /usr/bin


# install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


# get all zsh plugins
mkdir ~/.zsh_plugins
git clone https://github.com/olets/zsh-abbr --recurse-submodules --single-branch --branch main --depth 1 ~/.zsh_plugins/zsh-abbr
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.zsh_plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh_plugins/zsh-autosuggestions


# create .zshrc
cat > "$HOME/.zshrc" <<'EOF'
# === .zshrc contents start ===
eval "$(zoxide init zsh)"

### ---- autocompletions -----------------------------------
autoload -Uz compinit && compinit

### ---- Completion options and styling -----------------------------------
zstyle ':completion:*' menu select # selectable menu
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'  # case insensitive completion
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*' list-colors '' # colorize completion lists
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01' # colorize kill list


### ---- Load Starship -----------------------------------
eval "$(starship init zsh)"


# Aliases
# ---- switched to abbreviations ------------
alias grep='rg'
alias ls="eza --icons --group-directories-first -l"
alias ll="eza --icons --group-directories-first -la"

### ---- History Configuration -----------------------------------
HISTSIZE=100000               #How many lines of history to keep in memory
HISTFILE=$ZSH/.zsh_history     #Where to save history to disk
SAVEHIST=100000               #Number of history entries to save to disk
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space #ignores all commands starting with a blank space! Usefull for passwords

### ---- Source plugins -----------------------------------
export ZSH_PLUGINS=$HOME/.zsh_plugins
#### ---- fast-syntax-highlighting ------------------------
[ -f $ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source $ZSH_PLUGINS/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#### ---- zsh-autosuggestions ------------------------
[ -f $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#autosuggestion highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

#### ---- zsh-z ------------------------
eval "$(zoxide init zsh)"
autoload -U compinit; compinit # source after zsh-z again for autocompletion to work

#### ---- zsh-abbr ------------------------
[ -f $ZSH_PLUGINS/zsh-abbr/zsh-abbr.zsh ] && source $ZSH_PLUGINS/zsh-abbr/zsh-abbr.zsh

### ---- Load fzf completions and keybindings -----------------------------------
source <(fzf --zsh)
# -----------------------------------------------------------------------------------------

### ----- My personal settings -----------------------------------
export PATH="$HOME/.local/bin:$PATH"     # for local executables like pip to work properly

### SOPS AGE key setup ------------------
export SOPS_AGE_KEY_FILE=$HOME/.sops-age/key.txt
export SOPS_AGE_RECIPIENTS=$(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)")

# --- for some pasting issur ---- IDK
precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
EOF
echo ".zshrc written to $HOME/.zshrc"

# create starship.toml
mkdir -p $HOME/.config
cat > "$HOME/.config/starship.toml" <<'EOF'
# ~/.config/starship.toml

add_newline = false
command_timeout = 1000

format = """
$character\
$os$hostname\
$directory\
$git_branch\
$git_status \
$git_commit\
$python\
$package\
$buf\
$memory_usage\
$docker_context\
[](#1C3A5E)$time[](#1C3A5E)$cmd_duration
[└─>](bold green) """


continuation_prompt = '▶▶ '

[character]
success_symbol = "🚀 "
error_symbol = "🔥 "

[time]
disabled = false
time_format = "%r" # Hour:Minute Format
style = "bg:#1d2230"
format = '[[ ⏰ $time ](bg:#1C3A5E fg:#8DFBD2)]($style)'

[cmd_duration]
format = 'last command: [$duration](bold yellow)'

# ---

[os]
format = '[$symbol](bold white) '   
disabled = false

[os.symbols]
Windows = "🗔"
Ubuntu = "😎"

# Shows the hostname
[hostname]
ssh_only = false
format = 'on [$hostname](bold yellow) '
disabled = false
ssh_symbol = "🛡️ "

# Shows current directory
[directory]
truncation_length = 3
fish_style_pwd_dir_length=2
home_symbol = '🏠 ~'
read_only_style = '197'
read_only = ' 🔒 '
format = 'at [$path]($style)[$read_only]($read_only_style) '

# Shows current git branch
[git_branch]
symbol = "🌱 "
format = 'via [$symbol$branch]($style)'
# truncation_length = 4
truncation_symbol = '…/'
style = 'bold green'

# Shows current git status
[git_status]
format = '[$all_status$ahead_behind]($style) '
style = 'bold green'
conflicted = '⚔️'
up_to_date = '✓'
untracked = '🤷'
ahead = '⇡${count}'
diverged = '⇕⇡${ahead_count}⇣${behind_count}'
behind = '⇣${count}'
stashed = '🗳️'
modified = '📝'
staged = '[++\($count\)](green)'
renamed = '👅'
deleted = '🗑'

[git_commit]
commit_hash_length = 4
tag_symbol = '🔖 '


# ---

[buf]
symbol = "🐃 "

[c]
symbol = "C "

[docker_context]
symbol = "🐳 "

[memory_usage]
symbol = "🐏 "
disabled = true
style='bold dimmed white'
threshold = 1
format = "$symbol [${ram}(|${swap})]($style) "

[package]
symbol = "📦 "

[python]
symbol = "🐍 "
pyenv_version_name = true

EOF
echo ".starship written to $HOME/.config/starship.toml"

# create zsh-abbr
mkdir -p $HOME/.config/zsh-abbr
cat > "$HOME/.config/zsh-abbr/user-abbreviations" <<'EOF'
abbr "anplay"="docker run -ti --rm --network=host -v ~/.ssh/id_ed25519:/root/.ssh/id_ed25519 -v ~/.ssh/id_ed25519.pub:/root/.ssh/id_ed25519.pub -v $(pwd):/apps -w /apps alpine/ansible ansible-playbook -i inventory.yaml --ask-vault-password "
abbr "cls"="clear"
abbr "decompress"="tar -xzvf"
abbr "compress"="tar -czvf"
abbr "dcd"="docker compose down"
abbr "dcl"="docker compose logs -f"
abbr "dcupd"="docker compose up -d"
abbr "gamc"="git commit -am"
abbr "gp"="git push"
abbr "gts"="git status"
abbr "lab"="jupyter lab --no-browser --ip=0.0.0.0"
abbr "shut"="sudo shutdown -h now"

EOF
echo "zsh-abbr written to $HOME/.config/zsh-abbr/user-abbreviations"

# change shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh"
  chsh -s "$(which zsh)"
fi