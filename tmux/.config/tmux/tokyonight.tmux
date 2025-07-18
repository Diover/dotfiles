# TokyoNight colors for Tmux

set -g mode-style "fg=#2ac3de,bg=#3b4261"

set -g message-style "fg=#2ac3de,bg=#3b4261"
set -g message-command-style "fg=#2ac3de,bg=#3b4261"

set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#2ac3de"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#2ac3de,bg=#1f2335"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#15161E,bg=#2ac3de,bold] #S #[fg=#2ac3de,bg=#1f2335,nobold,nounderscore,noitalics]"
set -g status-right "Continuum status: #{continuum_status} #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#2ac3de,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#2ac3de,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#2ac3de,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161E,bg=##2ac3de,bold] #h "

setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#2ac3de,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"