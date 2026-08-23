# Custom global directory jumper using fd (from $HOME)

# Will be used to save the current folder in case we want to jump back
export LAST_VISITED_FOLDER=""

# Helper function to jump and record history
_jump_to_dir() {
  local target_path="$1"
  if [[ -n "$target_path" && -d "$target_path" ]]; then
    export LAST_VISITED_FOLDER="$PWD"
    cd "$target_path" || return
    zle reset-prompt
  fi
}

# 1. Global folder search via fzf (Ctrl+G, Ctrl+G)
fzf-cd-global-widget() {
  local target_dir
  target_dir=$(fd --type d --hidden --base-directory "$HOME" 2>/dev/null | fzf +m)
  if [[ -n "$target_dir" ]]; then
    _jump_to_dir "$HOME/$target_dir"
  fi
}

# Register the Zsh widget
zle -N fzf-cd-global-widget
bindkey '^G^G' fzf-cd-global-widget

# 2. Jump to Screenshots folder (Ctrl+G, Ctrl+S)
jump-screenshots-widget() {
  # Adjust path if your screenshots are saved elsewhere
  local screenshots_dir="$HOME/Documents/Screenshots"
  _jump_to_dir "$screenshots_dir"
}
zle -N jump-screenshots-widget
bindkey '^G^S' jump-screenshots-widget

# 3. Jump to Downloads folder (Ctrl+G, Ctrl+D)
jump-downloads-widget() {
  local downloads_dir="$HOME/Downloads"
  _jump_to_dir "$downloads_dir"
}
zle -N jump-downloads-widget
# Prevent Ctrl+D from logging out / closing the shell
setopt IGNORE_EOF
bindkey '^G^D' jump-downloads-widget

# Alias/function to jump back to the last visited folder
cdl() {
  if [[ -n "$LAST_VISITED_FOLDER" && -d "$LAST_VISITED_FOLDER" ]]; then
    local temp="$PWD"
    cd "$LAST_VISITED_FOLDER" || return
    export LAST_VISITED_FOLDER="$temp"
  else
    echo "cdl: No previous folder recorded."
  fi
}
