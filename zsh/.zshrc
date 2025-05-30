# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# vim mode: 
# set -o vi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ssmirnov/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ssmirnov/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ssmirnov/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ssmirnov/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

 # Set the history settings
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"
HISTFILE="/Users/ssmirnov/.zhistory"
HIST_STAMPS="yyyy-mm-dd"
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

unset ZSH_AUTOSUGGEST_USE_ASYNC

# Initialize starship.rs
eval "$(starship init zsh)"

# Prompt Engineering starship.rs
PROMPT_NEEDS_NEWLINE=false

precmd() {
  if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
    echo
  fi
  PROMPT_NEEDS_NEWLINE=true
}

clear() {
  PROMPT_NEEDS_NEWLINE=false
  command clear
}

# Append a path to user scripts at the end
path+=('/Users/ssmirnov/.local/bin')

###############################################################
#  to add local customizations, create '~/.localrc' and
#  add changes to it
###############################################################
[ -f "/Users/ssmirnov/.localrc" ] && source "/Users/ssmirnov/.localrc"

