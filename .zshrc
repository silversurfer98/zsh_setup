### ---- ZSH HOME -----------------------------------
export ZSH=$HOME/.zsh

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


### ---- Source other configs -----------------------------------
[[ -f $ZSH/config/aliases.zsh ]] && source $ZSH/config/aliases.zsh

### ---- History Configuration -----------------------------------
HISTSIZE=100000               #How many lines of history to keep in memory
HISTFILE=$ZSH/.zsh_history     #Where to save history to disk
SAVEHIST=100000               #Number of history entries to save to disk
setopt appendhistory
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space #ignores all commands starting with a blank space! Usefull for passwords

### ---- Source plugins -----------------------------------
[[ -f $ZSH/plugins/plugins.zsh ]] && source $ZSH/plugins/plugins.zsh

### ----- My personal settings -----------------------------------
export PATH="/home/raghav/.local/bin:$PATH"     # for local executables like pip to work properly
#alias ytd="python3.11 /home/raghav/playground/production/Youtbe-downloader/ytd.py"

### ---- Nvidia CUDA related ----------
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
export PATH="/usr/local/cuda/bin:$PATH"
export XLA_TARGET=cuda120
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/local/cuda

### SOPS AGE key setup ------------------
export SOPS_AGE_RECIPIENTS=$(cat ~/sops-key/key.txt |grep -oP "public key: \K(.*)")
export SOPS_AGE_KEY_FILE=$HOME/.sops-key/key.txt
#alias encryptenv='sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)") -i'
#alias decryptenv='sops --decrypt --age $(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)") -i'


# --- for some pasting issur ---- IDK
precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
