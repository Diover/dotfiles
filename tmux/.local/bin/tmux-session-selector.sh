if [ -n "$TMUX" ]; then
	tmux list-sessions -F '#{session_name}' |
		sed '/^$/d' |
		fzf --reverse --header jump-to-session --height=~100% |
		xargs tmux switch-client -t
else
	tmux attach-session -t "$(
		tmux list-sessions -F '#{session_name}' |
			sed '/^$/d' |
			fzf --reverse --header='jump-to-session' --height=~100%
	)"
fi
