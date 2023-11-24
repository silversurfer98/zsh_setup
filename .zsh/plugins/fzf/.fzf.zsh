# Setup fzf
# ---------
if [[ ! "$PATH" == *$ZSH/plugins/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$ZSH/plugins/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$ZSH/plugins/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$ZSH/plugins/fzf/shell/key-bindings.zsh"