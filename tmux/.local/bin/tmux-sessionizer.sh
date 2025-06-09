#!/usr/bin/env zsh
CONFIG_FILE="$HOME/.config/tmux-sessionizer/tmux-sessionizer.conf"

# test if the config file exists
if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
fi

sanity_check() {
  if ! command -v tmux &>/dev/null; then
    echo "tmux is not installed. Please install it first."
    exit 1
  fi

  if ! command -v fzf &>/dev/null; then
    echo "fzf is not installed. Please install it first."
    exit 1
  fi
}

switch_to() {
  if [[ -z $TMUX ]]; then
    tmux attach-session -t "$1"
  else
    tmux switch-client -t "$1"
  fi
}

has_session() {
  tmux list-sessions | grep -q "^$1:"
}

sanity_check

# if TS_SEARCH_PATHS is not set use default
if [ -z "${TS_SEARCH_PATHS+1}" ]; then
  TS_SEARCH_PATHS=(~/)
fi

# utility function to find directories
find_dirs() {
  # list TMUX sessions
  if [[ -n "${TMUX}" ]]; then
    current_session=$(tmux display-message -p '#S')
    tmux list-sessions -F "[OPEN] #{session_name}" 2>/dev/null | grep -vFx "$current_session"
  else
    tmux list-sessions -F "[OPEN] #{session_name}" 2>/dev/null
  fi

  # note: TS_SEARCH_PATHS is an array of paths to search for directories
  # if the path ends with :number, it will search for directories with a max depth of number ;)
  # if there is no number, it will search for directories with a max depth defined by TS_MAX_DEPTH or 1 if not set
  for entry in "${TS_SEARCH_PATHS[@]}"; do
    [[ -d "$entry" ]] && find "$entry" -mindepth 1 -maxdepth 1 -path '*/.git' -prune -o -type d -print
  done
}

if [[ $# -eq 1 ]]; then
  selected="$1"
else
  selected=$(find_dirs | fzf --reverse --header open-tmux-session --height="~100%" )
fi

if [[ -z $selected ]]; then
  exit 0
fi

if [[ "$selected" =~ "^\[OPEN\]\ (.+)$" ]]; then
  selected=$match[1]
fi
echo $selected

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

switch_to "$selected_name"
